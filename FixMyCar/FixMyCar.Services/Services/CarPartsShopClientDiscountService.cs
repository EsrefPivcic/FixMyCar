using AutoMapper;
using FixMyCar.Model.DTOs.CarPartsShopClientDiscount;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class CarPartsShopClientDiscountService : BaseService<CarPartsShopClientDiscount, CarPartsShopClientDiscountGetDTO, CarPartsShopClientDiscountInsertDTO, CarPartsShopClientDiscountUpdateDTO, CarPartsShopClientDiscountSearchObject>, ICarPartsShopClientDiscountService
    {
        public CarPartsShopClientDiscountService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<CarPartsShopClientDiscount> AddInclude(IQueryable<CarPartsShopClientDiscount> query, CarPartsShopClientDiscountSearchObject? search = null)
        {
            query = query.Include("CarRepairShop");
            query = query.Include("Client");
            return base.AddInclude(query, search);
        }

        public override IQueryable<CarPartsShopClientDiscount> AddFilter(IQueryable<CarPartsShopClientDiscount> query, CarPartsShopClientDiscountSearchObject? search = null)
        {
            if (search != null)
            {
                if (search?.CarPartsShopName != null)
                {
                    query = query.Where(x => x.CarPartsShop.Username == search.CarPartsShopName);
                }
                if (!string.IsNullOrEmpty(search?.Role))
                {
                    if (search?.Role == "Client")
                    {
                        query = query.Where(x => x.ClientId != null);
                    }
                    else
                    {
                        query = query.Where(x => x.CarRepairShopId != null);
                    }
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

        public async override Task<CarPartsShopClientDiscountGetDTO> Insert (CarPartsShopClientDiscountInsertDTO request)
        {
            var set = _context.Set<CarPartsShopClientDiscount>();

            CarPartsShopClientDiscount entity = _mapper.Map<CarPartsShopClientDiscount>(request);

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == request.Username) ?? throw new UserException("User not found");

            var carpartsshop = await _context.Users.FirstOrDefaultAsync(u => u.Username == request.CarPartsShopUsername) ?? throw new UserException("Car Parts Shop not found");

            if (await _context.CarPartsShopClientDiscounts
                .Where(x => (x.ClientId == user.Id || x.CarRepairShopId == user.Id) && 
                x.CarPartsShopId == carpartsshop.Id &&
                x.Revoked == null)
                .CountAsync() > 0)
            {
                throw new UserException("There is already an active discount for this user.");
            }

            if (user is Client)
            {
                entity.ClientId = user.Id;
            }
            else if (user is CarRepairShop)
            {
                entity.CarRepairShopId = user.Id;
            }
            else
            {
                throw new UserException("Invalid user type for discount");
            }

            entity.Created = DateTime.Now.Date;
            entity.CarPartsShopId = carpartsshop.Id;

            await set.AddAsync(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<CarPartsShopClientDiscountGetDTO>(entity);
        }
    }
}
