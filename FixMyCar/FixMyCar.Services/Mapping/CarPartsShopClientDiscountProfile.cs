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
            CreateMap<CarPartsShopClientDiscountInsertDTO, CarPartsShopClientDiscount>()
                .ForMember(dest => dest.ClientId, opt => opt.Ignore())
                .ForMember(dest => dest.CarRepairShopId, opt => opt.Ignore())
                .ForMember(dest => dest.Created, opt => opt.Ignore());
            CreateMap<CarPartsShopClientDiscountUpdateDTO, CarPartsShopClientDiscount>();
            CreateMap<CarPartsShopClientDiscount, CarPartsShopClientDiscountGetDTO>()
                .ForMember(dest => dest.User, opt => opt.MapFrom(src => src.Client != null ? src.Client.Username : src.CarRepairShop != null ? src.CarRepairShop.Username : null));
        }
    }
}
