using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShop;
using FixMyCar.Model.DTOs.Report;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.Utilities;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace FixMyCar.Services.Services
{
    public class CarRepairShopService : BaseService<CarRepairShop, CarRepairShopGetDTO, CarRepairShopInsertDTO, CarRepairShopUpdateDTO, CarRepairShopSearchObject>, ICarRepairShopService
    {
        ILogger<CarRepairShopService> _logger;
        private readonly RabbitMQService _rabbitMQService;
        public CarRepairShopService(FixMyCarContext context, IMapper mapper, ILogger<CarRepairShopService> logger, RabbitMQService rabbitMQService) : base(context, mapper)
        {
            _logger = logger;
            _rabbitMQService = rabbitMQService;
        }
        public override IQueryable<CarRepairShop> AddInclude(IQueryable<CarRepairShop> query, CarRepairShopSearchObject? search = null)
        {
            query = query.Include("Role");
            query = query.Include("City");
            return base.AddInclude(query, search);
        }

        public override IQueryable<CarRepairShop> AddFilter(IQueryable<CarRepairShop> query, CarRepairShopSearchObject? search = null)
        {
            if (search != null)
            {
                if (search?.Username != null)
                {
                    query = query.Where(u => u.Username == search.Username);
                }

                if (search!.ContainsUsername != null)
                {
                    query = query.Where(u => u.Username.Contains(search.ContainsUsername));
                }

                if (search!.Active != null)
                {
                    query = query.Where(u => u.Active == search.Active);
                }
            }

            return base.AddFilter(query, search);
        }

        public async Task GenerateReport(string username, ReportRequestDTO request)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            request.ShopId = shop!.Id;
            request.ShopName = username;
            request.ShopType = "carrepairshop";
            _rabbitMQService.SendReportGenerationRequest(request);
        }

        public async Task GenerateMonthlyReports(string username)
        {
            MonthlyReportRequestDTO request = new MonthlyReportRequestDTO();
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            request.ShopId = shop!.Id;
            request.ShopName = shop!.Username;
            request.ShopType = "carrepairshop";
            _rabbitMQService.SendMonthlyReportGenerationRequest(request);
        }

        public async Task<byte[]> GetReport(string username)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            var sharedVolumePath = "/app/reports";
            var reportFilePath = Path.Combine(sharedVolumePath, $"report_{shop.Id}.csv");

            if (File.Exists(reportFilePath))
            {
                return await File.ReadAllBytesAsync(reportFilePath);
            }

            return Array.Empty<byte>();
        }

        public async Task<byte[]> GetMonthlyRevenuePerReservationTypeReport(string username)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            var sharedVolumePath = "/app/reports";
            var reportFilePath = Path.Combine(sharedVolumePath, $"monthly_revenue_per_reservation_type_{shop.Id}.csv");

            if (File.Exists(reportFilePath))
            {
                return await File.ReadAllBytesAsync(reportFilePath);
            }

            return Array.Empty<byte>();
        }

        public async Task<byte[]> GetMonthlyRevenuePerDayReport(string username)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            var sharedVolumePath = "/app/reports";
            var reportFilePath = Path.Combine(sharedVolumePath, $"monthly_revenue_per_day_{shop.Id}.csv");

            if (File.Exists(reportFilePath))
            {
                return await File.ReadAllBytesAsync(reportFilePath);
            }

            return Array.Empty<byte>();
        }

        public async Task<byte[]> GetTop10CustomersMonthlyReport(string username)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            var sharedVolumePath = "/app/reports";
            var reportFilePath = Path.Combine(sharedVolumePath, $"top_10_customers_monthly_{shop.Id}.csv");

            if (File.Exists(reportFilePath))
            {
                return await File.ReadAllBytesAsync(reportFilePath);
            }

            return Array.Empty<byte>();
        }

        public async Task<byte[]> GetTop10ReservationsMonthlyReport(string username)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            var sharedVolumePath = "/app/reports";
            var reportFilePath = Path.Combine(sharedVolumePath, $"top_10_reservations_monthly_{shop.Id}.csv");

            if (File.Exists(reportFilePath))
            {
                return await File.ReadAllBytesAsync(reportFilePath);
            }

            return Array.Empty<byte>();
        }

        public async Task UpdateWorkDetails(CarRepairShopWorkDetailsUpdateDTO request)
        {
            var set = _context.Set<CarRepairShop>();
            var entity = await set.FirstOrDefaultAsync(u => u.Username == request.Username);

            if (entity != null)
            {
                entity.WorkDays = request.WorkDays;
                entity.OpeningTime = XmlConvert.ToTimeSpan(request.OpeningTime);
                entity.ClosingTime = XmlConvert.ToTimeSpan(request.ClosingTime);
                entity.WorkingHours = entity.ClosingTime - entity.OpeningTime;
                entity.Employees = request.Employees;

                await _context.SaveChangesAsync();
            }
            else
            {
                throw new UserException($"User {request.Username} doesn't exist");
            }
        }

        public override async Task BeforeInsert(CarRepairShop entity, CarRepairShopInsertDTO request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(x => x.Username == request.Username);

            if (user == null)
            {
                if (request.Password != request.PasswordConfirm)
                {
                    throw new UserException("Passwords must match.");
                }

                entity.PasswordSalt = Hashing.GenerateSalt();
                entity.PasswordHash = Hashing.GenerateHash(entity.PasswordSalt, request.Password);
                entity.Created = DateTime.Now.Date;

                City? city = await _context.Cities.FirstOrDefaultAsync(c => c.Name.ToLower() == request.City.ToLower());

                if (city != null)
                {
                    entity.CityId = city.Id;
                }
                else
                {
                    City newCity = new City
                    {
                        Name = request.City
                    };
                    await _context.Cities.AddAsync(newCity);
                    await _context.SaveChangesAsync();

                    entity.CityId = newCity.Id;
                }

                if (request.Image != null)
                {
                    byte[] newImage = Convert.FromBase64String(request.Image);
                    entity.Image = ImageHelper.Resize(newImage, 150);
                }
                else
                {
                    entity.Image = null;
                }

                entity.WorkingHours = XmlConvert.ToTimeSpan(request.ClosingTime) - XmlConvert.ToTimeSpan(request.OpeningTime);
                entity.Employees = request.Employees;
                entity.Active = false;

                await base.BeforeInsert(entity, request);
            }
            else
            {
                throw new UserException("This username is already in use.");
            }
        }
    }
}
