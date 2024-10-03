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
                .ForMember(dest => dest.Created, opt => opt.Ignore())
                .ForMember(dest => dest.CarPartsShopId, opt => opt.Ignore());
            CreateMap<CarPartsShopClientDiscountUpdateDTO, CarPartsShopClientDiscount>()
                .ForMember(dest => dest.Revoked, opt => opt.MapFrom(src => src.Revoked != null ? (src.Revoked == true ? DateTime.Now.Date : (DateTime?)null) : null));
            CreateMap<CarPartsShopClientDiscount, CarPartsShopClientDiscountGetDTO>()
                .ForMember(dest => dest.User, opt => opt.MapFrom(src => src.Client != null ? src.Client.Username : src.CarRepairShop != null ? src.CarRepairShop.Username : "Unknown"))
                .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Client != null ? "Client" : src.CarRepairShop != null ? "Car Repair Shop" : "Unknown"))
                .ForMember(dest => dest.CarPartsShop, opt => opt.MapFrom(src => src.CarPartsShop != null ? src.CarPartsShop.Username : "Unknown"));
        }
    }
}
