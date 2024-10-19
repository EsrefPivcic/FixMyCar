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

        public GenerateCarPartsShopReportService(FixMyCarContext context)
        {
            _context = context;
        }

        public async Task GenerateReport(ReportRequestDTO request)
        {
            var query = _context.Set<Order>().AsQueryable();

            query = query.Include(o => o.ClientDiscount)
                .Include(o => o.CarRepairShop)
                .Include(o => o.Client)
                .Include(o => o.OrderDetails)
                .ThenInclude(od => od.StoreItem)
                .Where(o => o.CarPartsShop.Username == request.ShopName);

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

            var fileName = $"report_{request.ShopName}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");

            using var rabbitMQService = new RabbitMQService();
            ReportNotificationDTO notification = new ReportNotificationDTO
            {
                Username = request.ShopName,
                NotificationType = "customreport",
                Message = "Custom report generated!"
            };
            rabbitMQService.SendReportNotification(notification);
        }

        public async Task GenerateMonthlyReports(string shopName)
        {
            await MonthlyRevenuePerCustomerType(shopName);
            await MonthlyRevenuePerDay(shopName);
            await Top10CustomersMonthly(shopName);
            await Top10OrdersMonthly(shopName);
            using var rabbitMQService = new RabbitMQService();
            ReportNotificationDTO notification = new ReportNotificationDTO
            {
                Username = shopName,
                NotificationType = "monthlystatistics",
                Message = "Monthly statistics updated!"
            };
            rabbitMQService.SendReportNotification(notification);
        }

        public async Task MonthlyRevenuePerCustomerType(string shopName)
        {
            var query = _context.Set<Order>().AsQueryable();

            DateTime oneMonthOlder = DateTime.Now.AddMonths(-1);

            query = query
                .Where(o => o.CarPartsShop.Username == shopName)
                .Where(o => o.OrderDate.Date >= oneMonthOlder.Date &&
                o.OrderDate.Date <= DateTime.Now.Date);

            var orders = await query.ToListAsync();

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
            csvReport.AppendLine($"Client,{clientsRevenue}");
            csvReport.AppendLine($"CarRepairShop,{repairShopsRevenue}");

            var fileName = $"monthly_revenue_per_customer_type_{shopName}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }

        public async Task MonthlyRevenuePerDay(string shopName)
        {
            var query = _context.Set<Order>().AsQueryable();

            DateTime oneMonthOlder = DateTime.Now.AddMonths(-1).Date;
            DateTime today = DateTime.Now.Date;

            query = query.Where(o => o.CarPartsShop.Username == shopName)
                .Where(o => o.OrderDate.Date >= oneMonthOlder &&
                            o.OrderDate.Date <= today);

            var orders = await query.ToListAsync();

            var csvReport = new StringBuilder();
            csvReport.AppendLine("Day,Revenue");

            for (DateTime date = oneMonthOlder; date <= today; date = date.AddDays(1))
            {
                var dailyOrders = orders
                    .Where(o => o.OrderDate.Date == date)
                    .ToList();

                double dailyRevenue = dailyOrders.Sum(o => o.TotalAmount);

                csvReport.AppendLine($"{date:yyyy-MM-dd},{dailyRevenue:F2}");
            }

            var fileName = $"monthly_revenue_per_day_{shopName}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }

        public async Task Top10CustomersMonthly(string shopName)
        {
            var query = _context.Set<Order>().AsQueryable();

            DateTime oneMonthOlder = DateTime.Now.AddMonths(-1).Date;
            DateTime today = DateTime.Now.Date;

            query = query.Include(o => o.Client)
                .Include(o => o.CarRepairShop)
                .Where(o => o.CarPartsShop.Username == shopName)
                .Where(o => o.OrderDate.Date >= oneMonthOlder &&
                            o.OrderDate.Date <= today);

            var orders = await query.ToListAsync();

            var ordersData = orders.Select(order => new
            {
                Customer = order.Client != null ? order.Client.Name + " " + order.Client.Surname + $" ({order.Client.Username})" :
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

            var fileName = $"top_10_customers_monthly_{shopName}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }

        public async Task Top10OrdersMonthly(string shopName)
        {
            var query = _context.Set<Order>().AsQueryable();

            DateTime oneMonthOlder = DateTime.Now.AddMonths(-1).Date;
            DateTime today = DateTime.Now.Date;

            query = query.Include(o => o.Client)
                .Include(o => o.CarRepairShop)
                .Include(o => o.ClientDiscount)
                .Where(o => o.CarPartsShop.Username == shopName)
                .Where(o => o.OrderDate.Date >= oneMonthOlder &&
                            o.OrderDate.Date <= today)
                .OrderByDescending(o => o.TotalAmount)
                .Take(10);

            var orders = await query.ToListAsync();

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
                csvReport.AppendLine($"{order.OrderDate},{customerInfo},{customerType},{order.TotalAmount:F2},{discount}");
            }

            var fileName = $"top_10_orders_monthly_{shopName}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }
    }
}
