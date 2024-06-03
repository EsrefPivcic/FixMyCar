using AutoMapper;
using FixMyCar.Model.DTOs.Discount;
using FixMyCar.Model.DTOs.Product;
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
    public class DiscountService : BaseService<Discount, DiscountGetDTO, DiscountInsertDTO, DiscountUpdateDTO, DiscountSearchObject>, IDiscountService
    {
        public DiscountService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Discount> AddFilter(IQueryable<Discount> query, DiscountSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Value.ToString()))
            {
                query = query.Where(x => x.Value == search.Value);
            }
            return base.AddFilter(query, search);
        }
    }
}