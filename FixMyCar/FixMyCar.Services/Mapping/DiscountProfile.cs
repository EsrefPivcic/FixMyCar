using AutoMapper;
using FixMyCar.Model.DTOs.Discount;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class DiscountProfile : Profile
    {
        public DiscountProfile()
        {
            CreateMap<DiscountInsertDTO, Discount>();
            CreateMap<DiscountUpdateDTO, Discount>();
            CreateMap<DiscountGetDTO, Discount>();
            CreateMap<Discount, DiscountInsertDTO>();
            CreateMap<Discount, DiscountUpdateDTO>();
            CreateMap<Discount, DiscountGetDTO>();
        }
    }
}