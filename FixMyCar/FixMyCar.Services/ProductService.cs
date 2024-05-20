using AutoMapper;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services
{
    public class ProductService : BaseService<ProductGetDTO, Product, ProductSearchObject>, IProductService
    {
        public ProductService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Product> AddFilter(IQueryable<Product> query, ProductSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Starts))
            {
                query = query.Where(x => x.Name.StartsWith(search.Starts));
            }

            if (!string.IsNullOrWhiteSpace(search?.Contains))
            {
                query = query.Where(x => x.Name.Contains(search.Contains));
            } 

            return base.AddFilter(query, search);
        }
    }
}