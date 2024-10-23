using FixMyCar.HelperAPI.Interfaces;
using FixMyCar.Model.DTOs.Report;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Stripe.Forwarding;
using System.Text;

namespace FixMyCar.HelperAPI.Services
{
    public class GenerateCarRepairShopReportService : IGenerateCarRepairShopReportService
    {
        private readonly FixMyCarContext _context;

        public GenerateCarRepairShopReportService(FixMyCarContext context)
        {
            _context = context;
        }
        public async Task GenerateReport(ReportRequestDTO request)
        {
            var query = _context.Set<Reservation>().AsQueryable();

            query = query.Include(r => r.CarRepairShopDiscount)
                .Include(r => r.Client)               .Include(r => r.ReservationDetails)
                .ThenInclude(rd => rd.CarRepairShopService)
                .Where(r => r.CarRepairShop.Username == request.ShopName);

            if (request.StartDate != null)
            {
                DateTime startDate = request.StartDate.Value;

                query = query.Where(r => r.ReservationCreatedDate.Date >= startDate.Date);
            }

            if (request.EndDate != null)
            {
                DateTime endDate = request.EndDate.Value;

                query = query.Where(r => r.ReservationCreatedDate.Date <= endDate.Date);
            }

            if (!request.Username.IsNullOrEmpty())
            {
                query = query.Where(r => r.Client.Username == request.Username);
            }

            var reservations = await query.ToListAsync();

            if (!reservations.IsNullOrEmpty()) {
                var reportData = reservations.Select(reservation => new
                {
                    ReservationId = reservation.Id,
                    ReservationCreatedDate = reservation.ReservationCreatedDate.ToString("yyyy-MM-dd"),
                    ReservationDate = reservation.ReservationDate.ToString("yyyy-MM-dd"),
                    Customer = reservation.Client.Name + " " + reservation.Client.Surname + $" ({reservation.Client.Username})",
                    TotalAmount = reservation.TotalAmount,
                    Type = reservation.Type,
                    PartsOrderedBy = reservation.ClientOrder == null ? "No order" : (bool)reservation.ClientOrder ? "Client" : "Shop",
                    ClientDiscount = reservation.CarRepairShopDiscount != null ? $"{(reservation.CarRepairShopDiscount.Value * 100):F2}%" : "No client discount",
                    Services = reservation.ReservationDetails.Select(rd => new
                    {
                        rd.ServiceName,
                        rd.ServicePrice,
                        Discount = rd.ServiceDiscount > 0 ? $"{(rd.ServiceDiscount * 100):F2}%" : "No service discount",
                        rd.ServiceDiscountedPrice
                    })
                }).ToList();

                var csvReport = new StringBuilder();
                csvReport.AppendLine("ReservationId,ReservationCreatedDate,ReservationDate,Customer," +
                    "TotalAmount,Type,PartsOrderedBy,ClientDiscount,ServiceName,ServicePrice,Discount,ServiceDiscountedPrice");

                foreach (var reservation in reportData)
                {
                    foreach (var service in reservation.Services)
                    {
                        csvReport.AppendLine($"{reservation.ReservationId},{reservation.ReservationCreatedDate:yyyy-MM-dd}," +
                            $"{reservation.ReservationDate:yyyy-MM-dd},{reservation.Customer},{reservation.TotalAmount:F2}," +
                            $"{reservation.Type},{reservation.PartsOrderedBy},{reservation.ClientDiscount},{service.ServiceName}," +
                            $"{service.ServicePrice:F2},{service.Discount},{service.ServiceDiscountedPrice:F2}");
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
                    Message = "New custom report generated!"
                };
                rabbitMQService.SendReportNotification(notification);
            }
            else
            {
                using var rabbitMQService = new RabbitMQService();
                ReportNotificationDTO notification = new ReportNotificationDTO
                {
                    Username = request.ShopName,
                    NotificationType = "customreport",
                    Message = "Can't generate report, there aren't any reservations!"
                };
                rabbitMQService.SendReportNotification(notification);
            }
        }

        public async Task GenerateMonthlyReports(string shopName)
        {
            var query = _context.Set<Reservation>().AsQueryable();

            DateTime oneMonthOlder = DateTime.Now.AddMonths(-1);

            query = query.Where(r => r.CarRepairShop.Username == shopName)
                .Where(r => r.ReservationCreatedDate.Date >= oneMonthOlder.Date &&
                r.ReservationCreatedDate.Date <= DateTime.Now.Date);

            var reservations = await query.ToListAsync();

            if (!reservations.IsNullOrEmpty())
            {
                await MonthlyRevenuePerReservationType(shopName, reservations);
                await MonthlyRevenuePerDay(shopName, reservations, oneMonthOlder);
                await Top10CustomersMonthly(shopName, reservations);
                await Top10ReservationsMonthly(shopName, reservations);
                using var rabbitMQService = new RabbitMQService();
                ReportNotificationDTO notification = new ReportNotificationDTO
                {
                    Username = shopName,
                    NotificationType = "monthlystatistics",
                    Message = "Monthly statistics updated!"
                };
                rabbitMQService.SendReportNotification(notification);
            }
            else
            {
                using var rabbitMQService = new RabbitMQService();
                ReportNotificationDTO notification = new ReportNotificationDTO
                {
                    Username = shopName,
                    NotificationType = "monthlystatistics",
                    Message = "Can't generate report, there are no reservations in the past month!"
                };
                rabbitMQService.SendReportNotification(notification);
            }
        }

        public async Task MonthlyRevenuePerReservationType(string shopName, List<Reservation> reservations)
        {
            double diagnosticsRevenue = 0;
            double repairsRevenue = 0;
            double repairsDiagnosticsRevenue = 0;

            foreach (var reservation in reservations)
            {
                if (reservation.Type == "Diagnostics")
                {
                    diagnosticsRevenue += reservation.TotalAmount;
                }
                else if (reservation.Type == "Repairs")
                {
                    repairsRevenue += reservation.TotalAmount;
                }
                else if (reservation.Type == "Repairs and Diagnostics")
                {
                    repairsDiagnosticsRevenue += reservation.TotalAmount;
                }
            }

            var csvReport = new StringBuilder();
            csvReport.AppendLine("ReservationType,Revenue");
            csvReport.AppendLine($"Diagnostics,{diagnosticsRevenue}");
            csvReport.AppendLine($"Repairs,{repairsRevenue}");
            csvReport.AppendLine($"Repairs and Diagnostics,{repairsDiagnosticsRevenue}");

            var fileName = $"monthly_revenue_per_reservation_type_{shopName}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }

        public async Task MonthlyRevenuePerDay(string shopName, List<Reservation> reservations, DateTime oneMonthOlder)
        {
            var csvReport = new StringBuilder();
            csvReport.AppendLine("Day,Revenue");

            for (DateTime date = oneMonthOlder; date <= DateTime.Now.Date; date = date.AddDays(1))
            {
                var dailyReservations = reservations
                    .Where(r => r.ReservationCreatedDate.Date == date)
                    .ToList();

                double dailyRevenue = dailyReservations.Sum(r => r.TotalAmount);

                csvReport.AppendLine($"{date:yyyy-MM-dd},{dailyRevenue:F2}");
            }

            var fileName = $"monthly_revenue_per_day_{shopName}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }

        public async Task Top10CustomersMonthly(string shopName, List<Reservation> reservations)
        {
            var customerRevenue = reservations
                .GroupBy(r => r.Client)
                .Select(group => new
                {
                    Client = group.Key,
                    TotalRevenue = group.Sum(r => r.TotalAmount)
                })
                .OrderByDescending(c => c.TotalRevenue)
                .Take(10)  
                .ToList();

            var csvReport = new StringBuilder();
            csvReport.AppendLine("Customer,Revenue");

            foreach (var customer in customerRevenue)
            {
                string customerInfo = $"{customer.Client.Name} {customer.Client.Surname} ({customer.Client.Username})";
                csvReport.AppendLine($"{customerInfo},{customer.TotalRevenue:F2}");
            }

            var fileName = $"top_10_customers_monthly_{shopName}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }

        public async Task Top10ReservationsMonthly(string shopName, List<Reservation> reservations)
        {
            var csvReport = new StringBuilder();
            csvReport.AppendLine("ReservationCreatedDate,ReservationDate,Customer,TotalAmount,Type,Discount");

            foreach (var reservation in reservations)
            {
                string customerInfo = $"{reservation.Client.Name} {reservation.Client.Surname} ({reservation.Client.Username})";
                string discount = reservation.CarRepairShopDiscountId != null
                    ? $"{(reservation.CarRepairShopDiscount.Value * 100):F2}%"
                    : "No discount";
                csvReport.AppendLine($"{reservation.ReservationCreatedDate},{reservation.ReservationDate},{customerInfo},{reservation.TotalAmount:F2},{reservation.Type},{discount}");
            }

            var fileName = $"top_10_reservations_monthly_{shopName}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }
    }
}
