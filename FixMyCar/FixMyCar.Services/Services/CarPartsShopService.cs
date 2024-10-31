using AutoMapper;
using FixMyCar.Model.DTOs.CarPartsShop;
using FixMyCar.Model.DTOs.Report;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.Utilities;
using Microsoft.AspNetCore.Connections.Features;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.VisualBasic;
using Stripe.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace FixMyCar.Services.Services
{
    public class CarPartsShopService : BaseService<CarPartsShop, CarPartsShopGetDTO, CarPartsShopInsertDTO, CarPartsShopUpdateDTO, CarPartsShopSearchObject>, ICarPartsShopService
    {
        ILogger<CarPartsShopService> _logger;
        private readonly RabbitMQService _rabbitMQService;

        public CarPartsShopService(FixMyCarContext context, IMapper mapper, ILogger<CarPartsShopService> logger, RabbitMQService rabbitMQService) : base(context, mapper)
        {
            _logger = logger;
            _rabbitMQService = rabbitMQService;
        }
        public override IQueryable<CarPartsShop> AddInclude(IQueryable<CarPartsShop> query, CarPartsShopSearchObject? search = null)
        {
            query = query.Include("Role");
            query = query.Include("City");
            return base.AddInclude(query, search);
        }

        public override IQueryable<CarPartsShop> AddFilter(IQueryable<CarPartsShop> query, CarPartsShopSearchObject? search = null)
        {
            if (search != null)
            {
                if (search!.Username != null)
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

        public async Task UpdateWorkDetails(CarPartsShopWorkDetailsUpdateDTO request)
        {
            var set = _context.Set<CarPartsShop>();
            var entity = await set.FirstOrDefaultAsync(u => u.Username == request.Username);

            if (entity != null)
            {
                entity.WorkDays = request.WorkDays;
                entity.OpeningTime = XmlConvert.ToTimeSpan(request.OpeningTime);
                entity.ClosingTime = XmlConvert.ToTimeSpan(request.ClosingTime);
                entity.WorkingHours = entity.ClosingTime - entity.OpeningTime;

                await _context.SaveChangesAsync();
            }
            else
            {
                throw new UserException($"User {request.Username} doesn't exist");
            }
        }

        public async Task GenerateReport(string username, ReportRequestDTO request)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            request.ShopId = shop!.Id;
            request.ShopName = username;
            request.ShopType = "carpartsshop";
            _rabbitMQService.SendReportGenerationRequest(request);
        }

        public async Task GenerateMonthlyReports(string username)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            MonthlyReportRequestDTO request = new MonthlyReportRequestDTO()
            {
                ShopId = shop!.Id,  
                ShopName = username,
                ShopType = "carpartsshop"
            };
            _rabbitMQService.SendMonthlyReportGenerationRequest(request);
        }

        public async Task<byte[]> GetReport(string username)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
            var solutionDirectory = Path.Combine(baseDirectory, "..", "..", "..", "..");
            var reportsFolderPath = Path.Combine(solutionDirectory, "FixMyCar.HelperAPI", "Reports"); 
            var reportFilePath = Path.Combine(reportsFolderPath, $"report_{shop.Id}.csv");

            if (File.Exists(reportFilePath))
            {
                return await File.ReadAllBytesAsync(reportFilePath);
            }

            return Array.Empty<byte>();
        }

        public async Task<byte[]> GetMonthlyRevenuePerCustomerTypeReport(string username)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
            var solutionDirectory = Path.Combine(baseDirectory, "..", "..", "..", "..");
            var reportsFolderPath = Path.Combine(solutionDirectory, "FixMyCar.HelperAPI", "Reports");
            var reportFilePath = Path.Combine(reportsFolderPath, $"monthly_revenue_per_customer_type_{shop.Id}.csv");

            if (File.Exists(reportFilePath))
            {
                return await File.ReadAllBytesAsync(reportFilePath);
            }

            return Array.Empty<byte>();
        }

        public async Task<byte[]> GetMonthlyRevenuePerDayReport(string username)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
            var solutionDirectory = Path.Combine(baseDirectory, "..", "..", "..", "..");
            var reportsFolderPath = Path.Combine(solutionDirectory, "FixMyCar.HelperAPI", "Reports");
            var reportFilePath = Path.Combine(reportsFolderPath, $"monthly_revenue_per_day_{shop.Id}.csv");

            if (File.Exists(reportFilePath))
            {
                return await File.ReadAllBytesAsync(reportFilePath);
            }

            return Array.Empty<byte>();
        }

        public async Task<byte[]> GetTop10CustomersMonthlyReport(string username)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
            var solutionDirectory = Path.Combine(baseDirectory, "..", "..", "..", "..");
            var reportsFolderPath = Path.Combine(solutionDirectory, "FixMyCar.HelperAPI", "Reports");
            var reportFilePath = Path.Combine(reportsFolderPath, $"top_10_customers_monthly_{shop.Id}.csv");

            if (File.Exists(reportFilePath))
            {
                return await File.ReadAllBytesAsync(reportFilePath);
            }

            return Array.Empty<byte>();
        }

        public async Task<byte[]> GetTop10OrdersMonthlyReport(string username)
        {
            var shop = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
            var solutionDirectory = Path.Combine(baseDirectory, "..", "..", "..", "..");
            var reportsFolderPath = Path.Combine(solutionDirectory, "FixMyCar.HelperAPI", "Reports");
            var reportFilePath = Path.Combine(reportsFolderPath, $"top_10_orders_monthly_{shop.Id}.csv");

            if (File.Exists(reportFilePath))
            {
                return await File.ReadAllBytesAsync(reportFilePath);
            }

            return Array.Empty<byte>();
        }

        public override async Task BeforeInsert(CarPartsShop entity, CarPartsShopInsertDTO request)
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
                    var citySet = _context.Set<City>();
                    City newCity = new City
                    {
                        Name = request.City
                    };
                    await citySet.AddAsync(newCity);
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
                    var partsshopimgpath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "parts-shop.png");
                    byte[] partsshopimg = ImageHelper.GetImageData(partsshopimgpath);
                    entity.Image = ImageHelper.Resize(partsshopimg, 150);
                }

                entity.WorkingHours = XmlConvert.ToTimeSpan(request.ClosingTime) - XmlConvert.ToTimeSpan(request.OpeningTime);
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