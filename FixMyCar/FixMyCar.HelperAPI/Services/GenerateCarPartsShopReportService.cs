using FixMyCar.HelperAPI.Interfaces;
using FixMyCar.Model.DTOs.Report;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;

namespace FixMyCar.HelperAPI.Services
{
    public class GenerateCarPartsShopReportService : IGenerateCarPartsShopReportService
    {
        private readonly FixMyCarContext _context;
        private readonly RabbitMQService _rabbitMQService;

        public GenerateCarPartsShopReportService(FixMyCarContext context, RabbitMQService rabbitMQService)
        {
            _context = context;
            _rabbitMQService = rabbitMQService;
        }

        public async Task GenerateReport(ReportRequestDTO request)
        {
            var query = _context.Set<Order>().AsQueryable();

            query = query.Include(o => o.ClientDiscount)
                .Include(o => o.CarRepairShop)
                .Include(o => o.Client)
                .Include(o => o.OrderDetails)
                .ThenInclude(od => od.StoreItem)
                .Where(o => o.CarPartsShopId == request.ShopId);

            if (request.StartDate != null)
            {
                DateTime startDate = request.StartDate.Value;

                query = query.Where(o => o.OrderDate.Date >= startDate.Date);
            }

            if (request.EndDate != null)
            {
                DateTime endDate = request.EndDate.Value;

                query = query.Where(o => o.OrderDate.Date <= endDate.Date);
            }

            if (!request.Role.IsNullOrEmpty())
            {
                if (request.Role == "client")
                {
                    query = query.Where(o => o.Client != null);

                    if (!request.Username.IsNullOrEmpty())
                    {
                        query = query.Where(o => o.Client!.Username == request.Username);
                    }
                }
                else if (request.Role == "carrepairshop")
                {
                    query = query.Where(o => o.CarRepairShop != null);

                    if (!request.Username.IsNullOrEmpty())
                    {
                        query = query.Where(o => o.CarRepairShop!.Username == request.Username);
                    }
                }
                else
                {
                    throw new UserException("Not allowed.");
                }
            }

            var orders = await query.ToListAsync();

            if (!orders.IsNullOrEmpty())
            {
                var reportData = orders.Select(order => new
                {
                    OrderId = order.Id,
                    OrderDate = order.OrderDate.ToString("yyyy-MM-dd"),
                    Customer = order.Client != null ? order.Client.Name + " " + order.Client.Surname + $" ({order.Client.Username})" :
                order.CarRepairShop!.Name + " " + order.CarRepairShop.Surname + $" ({order.CarRepairShop.Username})",
                    CustomerType = order.Client != null ? "Client" : "Car Repair Shop",
                    TotalAmount = order.TotalAmount,
                    ShippingDate = order.ShippingDate?.ToString("yyyy-MM-dd") ?? "Pending",
                    ClientDiscount = order.ClientDiscount != null ? $"{(order.ClientDiscount.Value * 100):F2}%" : "No client discount",
                    StoreItems = order.OrderDetails.Select(od => new
                    {
                        od.StoreItem.Name,
                        od.Quantity,
                        od.UnitPrice,
                        Discount = od.Discount > 0 ? $"{(od.Discount * 100):F2}%" : "No item discount",
                        od.TotalItemsPrice,
                        od.TotalItemsPriceDiscounted
                    })
                }).ToList();

                var csvReport = new StringBuilder();
                csvReport.AppendLine("OrderId,OrderDate,Customer,CustomerType,TotalAmount,ShippingDate,ClientDiscount,StoreItemName,Quantity,UnitPrice,TotalItemsPrice,Discount,TotalItemsPriceDiscounted");

                foreach (var order in reportData)
                {
                    foreach (var item in order.StoreItems)
                    {
                        csvReport.AppendLine($"{order.OrderId},{order.OrderDate:yyyy-MM-dd},{order.Customer},{order.CustomerType},{order.TotalAmount:F2},{order.ShippingDate},{order.ClientDiscount},{item.Name},{item.Quantity},{item.UnitPrice:F2},{item.TotalItemsPrice:F2},{item.Discount},{item.TotalItemsPriceDiscounted:F2}");
                    }
                }

                var fileName = $"report_{request.ShopId}.csv";
                var filePath = Path.Combine("Reports", fileName);

                try
                {
                    await File.WriteAllTextAsync(filePath, csvReport.ToString());

                    Console.WriteLine($"Report generated and saved at {filePath}");

                    ReportNotificationDTO notification = new ReportNotificationDTO
                    {
                        Username = request.ShopName,
                        NotificationType = "customreport",
                        Message = "Custom report generated!"
                    };
                    _rabbitMQService.SendReportNotification(notification);
                }
                catch (Exception)
                {
                    ReportNotificationDTO notification = new ReportNotificationDTO
                    {
                        Username = request.ShopName,
                        NotificationType = "customreport",
                        Message = "Warning! Your previous request is still processing. Please wait."
                    };
                    _rabbitMQService.SendReportNotification(notification);
                }
            }
            else
            {
                ReportNotificationDTO notification = new ReportNotificationDTO
                {
                    Username = request.ShopName,
                    NotificationType = "customreport",
                    Message = "Warning! Can't generate report, there aren't any orders!"
                };
                _rabbitMQService.SendReportNotification(notification);
            }
        }

        public async Task GenerateMonthlyReports(MonthlyReportRequestDTO request)
        {
            var query = _context.Set<Order>().AsQueryable();

            DateTime oneMonthOlder = DateTime.Now.AddMonths(-1).Date;

            query = query.Include(o => o.CarRepairShop)
                .Include(o => o.Client)
                .Include(o => o.OrderDetails)
                .Include(o => o.ClientDiscount)
                .Where(o => o.CarPartsShopId == request.ShopId)
                .Where(o => o.OrderDate.Date >= oneMonthOlder.Date &&
                o.OrderDate.Date <= DateTime.Now.Date);

            var orders = await query.ToListAsync();

            if (!orders.IsNullOrEmpty())
            {
                try
                {
                    await MonthlyRevenuePerCustomerType(request.ShopId, orders);
                    await MonthlyRevenuePerDay(request.ShopId, orders, oneMonthOlder.Date);
                    await Top10CustomersMonthly(request.ShopId, orders);
                    await Top10OrdersMonthly(request.ShopId, orders);
                    ReportNotificationDTO notification = new ReportNotificationDTO
                    {
                        Username = request.ShopName,
                        NotificationType = "monthlystatistics",
                        Message = "Monthly statistics updated!"
                    };
                    _rabbitMQService.SendReportNotification(notification);
                }
                catch (Exception)
                {
                    ReportNotificationDTO notification = new ReportNotificationDTO
                    {
                        Username = request.ShopName,
                        NotificationType = "monthlystatistics",
                        Message = "Warning! Your previous request is still processing. Please wait."
                    };
                    _rabbitMQService.SendReportNotification(notification);
                }
            }
            else
            {
                ReportNotificationDTO notification = new ReportNotificationDTO
                {
                    Username = request.ShopName,
                    NotificationType = "monthlystatistics",
                    Message = "Can't generate report, there are no orders in the past month!"
                };
                _rabbitMQService.SendReportNotification(notification);
            }
        }

        public async Task MonthlyRevenuePerCustomerType(int shopId, List<Order> orders)
        {
            double clientsRevenue = 0;
            double repairShopsRevenue = 0;

            foreach (var order in orders)
            {
                if (order.ClientId != null)
                {
                    clientsRevenue += order.TotalAmount;
                }
                else if (order.CarRepairShopId != null)
                {
                    repairShopsRevenue += order.TotalAmount;
                }
            }

            var csvReport = new StringBuilder();
            csvReport.AppendLine("CustomerType,Revenue");
            csvReport.AppendLine($"Client,{clientsRevenue:F2}");
            csvReport.AppendLine($"CarRepairShop,{repairShopsRevenue:F2}");

            var fileName = $"monthly_revenue_per_customer_type_{shopId}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }

        public async Task MonthlyRevenuePerDay(int shopId, List<Order> orders, DateTime oneMonthOlder)
        {
            var csvReport = new StringBuilder();
            csvReport.AppendLine("Day,Revenue");

            for (DateTime date = oneMonthOlder; date <= DateTime.Now.Date; date = date.AddDays(1))
            {
                var dailyOrders = orders
                    .Where(o => o.OrderDate.Date == date.Date)
                    .ToList();

                double dailyRevenue = dailyOrders.Sum(o => o.TotalAmount);

                csvReport.AppendLine($"{date:yyyy-MM-dd},{dailyRevenue:F2}");
            }

            var fileName = $"monthly_revenue_per_day_{shopId}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }

        public async Task Top10CustomersMonthly(int shopId, List<Order> orders)
        {
            var ordersData = orders.Select(order => new
            {
                Customer = order.ClientId != null ? order.Client.Name + " " + order.Client.Surname + $" ({order.Client.Username})" :
                order.CarRepairShop!.Name + " " + order.CarRepairShop.Surname + $" ({order.CarRepairShop.Username})",
                TotalAmount = order.TotalAmount,
            }).ToList();

            var customerRevenue = ordersData
                .GroupBy(o => o.Customer)
                .Select(group => new
                {
                    Customer = group.Key,
                    TotalRevenue = group.Sum(o => o.TotalAmount)
                })
                .OrderByDescending(c => c.TotalRevenue)
                .Take(10)
                .ToList();

            var csvReport = new StringBuilder();
            csvReport.AppendLine("Customer,Revenue");

            foreach (var customer in customerRevenue)
            {
                string customerInfo = $"{customer.Customer}";
                csvReport.AppendLine($"{customerInfo},{customer.TotalRevenue:F2}");
            }

            var fileName = $"top_10_customers_monthly_{shopId}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }

        public async Task Top10OrdersMonthly(int shopId, List<Order> orders)
        {
            var csvReport = new StringBuilder();
            csvReport.AppendLine("OrderDate,Customer,CustomerType,TotalAmount,Discount");

            foreach (var order in orders)
            {
                string customerInfo = order.Client != null ? $"{order.Client.Name} {order.Client.Surname} ({order.Client.Username})"
                    : $"{order.CarRepairShop!.Name} {order.CarRepairShop.Surname} ({order.CarRepairShop.Username})";
                string discount = order.ClientDiscountId != null
                    ? $"{(order.ClientDiscount!.Value * 100):F2}%"
                    : "No discount";
                string customerType = order.ClientId != null ? "Client" : "Car Repair Shop";
                csvReport.AppendLine($"{order.OrderDate:yyyy-MM-dd},{customerInfo},{customerType},{order.TotalAmount:F2},{discount}");
            }

            var fileName = $"top_10_orders_monthly_{shopId}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }
    }
}
