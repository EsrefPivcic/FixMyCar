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
    public class GenerateReportService : IGenerateReportService
    {
        private readonly FixMyCarContext _context;

        public GenerateReportService(FixMyCarContext context)
        {
            _context = context;
        }

        public async Task GenerateReportCarPartsShop(ReportRequestDTO request)
        {
            var query = _context.Set<Order>().AsQueryable();

            query = query.Include(o => o.ClientDiscount)
                .Include(o => o.CarRepairShop)
                .Include(o => o.Client)
                .Include(o => o.OrderDetails)
                .ThenInclude(od => od.StoreItem);

            if (request.StartDate != null)
            {
                DateTime startDate = request.StartDate.Value;

                query = query.Where(o => o.CarPartsShop.Username == request.ShopName
                         && o.OrderDate.Date >= startDate.Date);
            }

            if (request.EndDate != null)
            {
                DateTime endDate = request.EndDate.Value;

                query = query.Where(o => o.CarPartsShop.Username == request.ShopName
                         && o.OrderDate.Date <= endDate.Date);
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
        }


        public async Task GenerateReportCarRepairShop(ReportRequestDTO request)
        {
            Console.WriteLine($"Generating report for {request.ShopName} " + $"({request.ShopType}) " +
                              $"from {request.StartDate} to {request.EndDate}");
        }
    }
}
