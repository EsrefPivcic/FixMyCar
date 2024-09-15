using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShop;
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
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace FixMyCar.Services.Services
{
    public class CarRepairShopService : BaseService<CarRepairShop, CarRepairShopGetDTO, CarRepairShopInsertDTO, CarRepairShopUpdateDTO, CarRepairShopSearchObject>, ICarRepairShopService
    {
        ILogger<CarRepairShopService> _logger;
        public CarRepairShopService(FixMyCarContext context, IMapper mapper, ILogger<CarRepairShopService> logger) : base (context, mapper) 
        {
            _logger = logger;
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
            }

            return base.AddFilter(query, search);
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
                    var repairshopimgpath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Utilities", "Images", "repair-shop.png");
                    byte[] repairshopimg = ImageHelper.GetImageData(repairshopimgpath);
                    entity.Image = ImageHelper.Resize(repairshopimg, 150);
                }

                entity.WorkingHours = XmlConvert.ToTimeSpan(request.ClosingTime) - XmlConvert.ToTimeSpan(request.OpeningTime);
                await base.BeforeInsert(entity, request);
            }
            else
            {
                throw new UserException("This username is already in use.");
            }
        }
    }
}
