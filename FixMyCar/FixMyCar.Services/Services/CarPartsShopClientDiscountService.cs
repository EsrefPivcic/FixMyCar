using AutoMapper;
using FixMyCar.Model.DTOs.CarPartsShopClientDiscount;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
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
    public class CarPartsShopClientDiscountService : BaseService<CarPartsShopClientDiscount, CarPartsShopClientDiscountGetDTO, CarPartsShopClientDiscountInsertDTO, CarPartsShopClientDiscountUpdateDTO, CarPartsShopClientDiscountSearchObject>, ICarPartsShopClientDiscountService
    {
        public CarPartsShopClientDiscountService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<CarPartsShopClientDiscount> AddInclude(IQueryable<CarPartsShopClientDiscount> query, CarPartsShopClientDiscountSearchObject? search = null)
        {
            query = query.Include("User");
            return base.AddInclude(query, search);
        }
    }
}
