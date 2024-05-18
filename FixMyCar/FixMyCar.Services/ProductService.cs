using AutoMapper;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services
{
    public class ProductService : BaseService<ProductGetDTO, Product>, IProductService
    {
        public ProductService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}