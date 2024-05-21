using AutoMapper;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class ProductProfile : Profile
    {
        public ProductProfile() 
        {
            CreateMap<ProductInsertDTO, Product>();
            CreateMap<ProductUpdateDTO, Product>();
            CreateMap<ProductGetDTO, Product>();
            CreateMap<Product, ProductInsertDTO>();
            CreateMap<Product, ProductUpdateDTO>();
            CreateMap<Product, ProductGetDTO>();
        }
    }
}