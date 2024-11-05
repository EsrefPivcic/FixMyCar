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
        private readonly RabbitMQService _rabbitMQService;

        public GenerateCarRepairShopReportService(FixMyCarContext context, RabbitMQService rabbitMQService)
        {
            _context = context;
            _rabbitMQService = rabbitMQService;
        }
        public async Task GenerateReport(ReportRequestDTO request)
        {
            var query = _context.Set<Reservation>().AsQueryable();

            query = query.Include(r => r.CarRepairShopDiscount)
                .Include(r => r.Client)
                .Include(r => r.ReservationDetails)
                .ThenInclude(rd => rd.CarRepairShopService)
                .Where(r => r.CarRepairShopId == request.ShopId && (r.State == "ongoing" || r.State == "completed" || r.State == "accepted"));

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

            if (!request.ReservationType.IsNullOrEmpty())
            {
                query = query.Where(r => r.Type == request.ReservationType);
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
                        Message = "New custom report generated!"
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
                    Message = "Can't generate report, there aren't any reservations!"
                };
                _rabbitMQService.SendReportNotification(notification);
            }
        }

        public async Task GenerateMonthlyReports(MonthlyReportRequestDTO request)
        {
            var query = _context.Set<Reservation>().AsQueryable();

            DateTime oneMonthOlder = DateTime.Now.AddMonths(-1);

            query = query.Include(r => r.Client)
                .Include(r => r.ReservationDetails)
                .Include(r => r.CarRepairShopDiscount)
                .Where(r => r.CarRepairShopId == request.ShopId)
                .Where(r => r.ReservationCreatedDate.Date >= oneMonthOlder.Date &&
                r.ReservationCreatedDate.Date <= DateTime.Now.Date)
                .Where(r => r.State == "ongoing" || r.State == "completed" || r.State == "accepted");

            var reservations = await query.ToListAsync();

            if (!reservations.IsNullOrEmpty())
            {
                try
                {
                    await MonthlyRevenuePerReservationType(request.ShopId, reservations);
                    await MonthlyRevenuePerDay(request.ShopId, reservations, oneMonthOlder.Date);
                    await Top10CustomersMonthly(request.ShopId, reservations);
                    await Top10ReservationsMonthly(request.ShopId, reservations);
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
                    Message = "Can't generate report, there are no reservations in the past month!"
                };
                _rabbitMQService.SendReportNotification(notification);
            }
        }

        public async Task MonthlyRevenuePerReservationType(int shopId, List<Reservation> reservations)
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
            csvReport.AppendLine($"Diagnostics,{diagnosticsRevenue:F2}");
            csvReport.AppendLine($"Repairs,{repairsRevenue:F2}");
            csvReport.AppendLine($"Repairs and Diagnostics,{repairsDiagnosticsRevenue:F2}");

            var fileName = $"monthly_revenue_per_reservation_type_{shopId}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }

        public async Task MonthlyRevenuePerDay(int shopId, List<Reservation> reservations, DateTime oneMonthOlder)
        {
            var csvReport = new StringBuilder();
            csvReport.AppendLine("Day,Revenue");

            for (DateTime date = oneMonthOlder; date <= DateTime.Now.Date; date = date.AddDays(1))
            {
                var dailyReservations = reservations
                    .Where(r => r.ReservationCreatedDate.Date == date.Date)
                    .ToList();

                double dailyRevenue = dailyReservations.Sum(r => r.TotalAmount);

                csvReport.AppendLine($"{date:yyyy-MM-dd},{dailyRevenue:F2}");
            }

            var fileName = $"monthly_revenue_per_day_{shopId}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }

        public async Task Top10CustomersMonthly(int shopId, List<Reservation> reservations)
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

            var fileName = $"top_10_customers_monthly_{shopId}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }

        public async Task Top10ReservationsMonthly(int shopId, List<Reservation> reservations)
        {
            var csvReport = new StringBuilder();
            csvReport.AppendLine("ReservationCreatedDate,ReservationDate,Customer,TotalAmount,Type,Discount");

            reservations = reservations.OrderByDescending(r => r.TotalAmount).ToList();

            foreach (var reservation in reservations)
            {
                string customerInfo = $"{reservation.Client.Name} {reservation.Client.Surname} ({reservation.Client.Username})";
                string discount = reservation.CarRepairShopDiscountId != null
                    ? $"{(reservation.CarRepairShopDiscount.Value * 100):F2}%"
                    : "No discount";
                csvReport.AppendLine($"{reservation.ReservationCreatedDate:yyyy-MM-dd},{reservation.ReservationDate:yyyy-MM-dd},{customerInfo},{reservation.TotalAmount:F2},{reservation.Type},{discount}");
            }

            var fileName = $"top_10_reservations_monthly_{shopId}.csv";
            var filePath = Path.Combine("Reports", fileName);

            await File.WriteAllTextAsync(filePath, csvReport.ToString());

            Console.WriteLine($"Report generated and saved at {filePath}");
        }
    }
}
