using AutoMapper;
using FixMyCar.Model.DTOs.CarPartsShop;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
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

namespace FixMyCar.Services.Services
{
    public class CarPartsShopService : BaseService<CarPartsShop, CarPartsShopGetDTO, CarPartsShopInsertDTO, CarPartsShopUpdateDTO, CarPartsShopSearchObject>, ICarPartsShopService
    {
        ILogger<CarPartsShopService> _logger;
        public CarPartsShopService(FixMyCarContext context, IMapper mapper, ILogger<CarPartsShopService> logger) : base(context, mapper)
        {
            _logger = logger;
        }
        public override IQueryable<CarPartsShop> AddInclude(IQueryable<CarPartsShop> query, CarPartsShopSearchObject? search = null)
        {
            query = query.Include("Role");
            query = query.Include("City");
            return base.AddInclude(query, search);
        }

        public override async Task BeforeInsert(CarPartsShop entity, CarPartsShopInsertDTO request)
        {
            _logger.LogInformation($"Adding user: {entity.Username}");

            if (request.Password != request.PasswordConfirm)
            {
                throw new Exception("Passwords must match.");
            }

            entity.PasswordSalt = Hashing.GenerateSalt();
            entity.PasswordHash = Hashing.GenerateHash(entity.PasswordSalt, request.Password);
            entity.Created = DateTime.Now.Date;

            using var transaction = await _context.Database.BeginTransactionAsync();
            City city = await _context.Cities.FirstOrDefaultAsync(c => c.Name.ToLower() == request.City.ToLower());

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

                newCity = await _context.Cities.FirstOrDefaultAsync(c => c.Name.ToLower() == request.City.ToLower());
                entity.CityId = newCity.Id;
            }

            await _context.SaveChangesAsync();

            await transaction.CommitAsync();

            await base.BeforeInsert(entity, request);
        }
    }
}
