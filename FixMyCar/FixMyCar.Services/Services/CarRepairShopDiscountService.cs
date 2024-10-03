using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShopDiscount;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class CarRepairShopDiscountService : BaseService<CarRepairShopDiscount, CarRepairShopDiscountGetDTO, CarRepairShopDiscountInsertDTO, CarRepairShopDiscountUpdateDTO, CarRepairShopDiscountSearchObject>, ICarRepairShopDiscountService
    {
        public CarRepairShopDiscountService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<CarRepairShopDiscount> AddInclude(IQueryable<CarRepairShopDiscount> query, CarRepairShopDiscountSearchObject? search = null)
        {
            query = query.Include("Client");
            query = query.Include("CarRepairShop");
            return base.AddInclude(query, search);
        }

        public override IQueryable<CarRepairShopDiscount> AddFilter(IQueryable<CarRepairShopDiscount> query, CarRepairShopDiscountSearchObject? search = null)
        {
            if (search != null)
            {
                if (search?.ClientName != null)
                {
                    query = query.Where(x => x.Client.Username == search.ClientName);
                }
                if (search?.CarRepairShopName != null)
                {
                    query = query.Where(x => x.CarRepairShop.Username == search.CarRepairShopName);
                }
                if (search?.Active != null)
                {
                    if (search?.Active == true)
                    {
                        query = query.Where(x => x.Revoked == null);
                    }
                    else
                    {
                        query = query.Where(x => x.Revoked != null);
                    }
                }
            }
            return base.AddFilter(query, search);
        }

        public async override Task<CarRepairShopDiscountGetDTO> Insert(CarRepairShopDiscountInsertDTO request)
        {
            var set = _context.Set<CarRepairShopDiscount>();

            CarRepairShopDiscount entity = _mapper.Map<CarRepairShopDiscount>(request);

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == request.Username) ?? throw new UserException("User not found");

            var carrepairshop = await _context.Users.FirstOrDefaultAsync(u => u.Username == request.CarRepairShopUsername) ?? throw new UserException("Car Repair Shop not found");

            if (await _context.CarRepairShopDiscounts
                .Where(x => (x.ClientId == user.Id) &&
                x.CarRepairShopId == carrepairshop.Id &&
                x.Revoked == null)
                .CountAsync() > 0)
            {
                throw new UserException("There is already an active discount for this user.");
            }

            entity.ClientId = user.Id;

            entity.Created = DateTime.Now.Date;
            entity.CarRepairShopId = carrepairshop.Id;

            await set.AddAsync(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<CarRepairShopDiscountGetDTO>(entity);
        }
    }
}
