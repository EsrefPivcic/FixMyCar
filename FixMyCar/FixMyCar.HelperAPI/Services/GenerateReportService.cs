using FixMyCar.HelperAPI.Interfaces;
using FixMyCar.Model.DTOs.Report;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
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
            var orders = await _context.Orders
                .Include(o => o.ClientDiscount)
                .Include(o => o.OrderDetails)
                .ThenInclude(od => od.StoreItem)
                .Where(o => o.CarPartsShop.Username == request.ShopName
                         && o.OrderDate >= request.StartDate
                         && o.OrderDate <= request.EndDate)
                .ToListAsync();

            var reportData = orders.Select(order => new
            {
                OrderId = order.Id,
                OrderDate = order.OrderDate.ToString("yyyy-MM-dd"),
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
            csvReport.AppendLine("OrderId,OrderDate,TotalAmount,ShippingDate,ClientDiscount,StoreItemName,Quantity,UnitPrice,TotalItemsPrice,Discount,TotalItemsPriceDiscounted");

            foreach (var order in reportData)
            {
                foreach (var item in order.StoreItems)
                {
                    csvReport.AppendLine($"{order.OrderId},{order.OrderDate:yyyy-MM-dd},{order.TotalAmount:F2},{order.ShippingDate},{order.ClientDiscount},{item.Name},{item.Quantity},{item.UnitPrice:F2},{item.TotalItemsPrice:F2},{item.Discount},{item.TotalItemsPriceDiscounted:F2}");
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
