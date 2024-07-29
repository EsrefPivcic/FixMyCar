using AutoMapper;
using FixMyCar.Model.DTOs.CarPartsShopClientDiscount;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class CarPartsShopClientDiscountProfile : Profile
    {
        public CarPartsShopClientDiscountProfile() {
            CreateMap<CarPartsShopClientDiscountInsertDTO, CarPartsShopClientDiscount>();
            CreateMap<CarPartsShopClientDiscountUpdateDTO, CarPartsShopClientDiscount>();
            CreateMap<CarPartsShopClientDiscount, CarPartsShopClientDiscountGetDTO>()
                .ForMember(dest => dest.User, opt => opt.MapFrom(src => src.User.Username != null ? src.User.Username : string.Empty));
        }
    }
}
