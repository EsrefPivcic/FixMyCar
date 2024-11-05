using AutoMapper;
using FixMyCar.Model.DTOs.StoreItemCategory;
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
    public class StoreItemCategoryService : BaseReadOnlyService<StoreItemCategory, StoreItemCategoryGetDTO, StoreItemCategorySearchObject>, IStoreItemCategoryService
    {
        public StoreItemCategoryService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<StoreItemCategory> AddFilter(IQueryable<StoreItemCategory> query, StoreItemCategorySearchObject? search = null)
        {
            query = query.OrderBy(sc => sc.Name);
            return base.AddFilter(query, search);
        }
    }
}
