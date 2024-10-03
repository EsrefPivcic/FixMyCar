using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShopDiscount;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class CarRepairShopDiscountProfile : Profile
    {
        public CarRepairShopDiscountProfile()
        {
            CreateMap<CarRepairShopDiscountInsertDTO, CarRepairShopDiscount>()
                .ForMember(dest => dest.ClientId, opt => opt.Ignore())
                .ForMember(dest => dest.CarRepairShopId, opt => opt.Ignore())
                .ForMember(dest => dest.Created, opt => opt.Ignore());
            CreateMap<CarRepairShopDiscountUpdateDTO, CarRepairShopDiscount>()
                .ForMember(dest => dest.Revoked, opt => opt.MapFrom(src => src.Revoked != null ? (src.Revoked == true ? DateTime.Now.Date : (DateTime?)null) : null))
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));
            CreateMap<CarRepairShopDiscount, CarRepairShopDiscountGetDTO>()
                .ForMember(dest => dest.Client, opt => opt.MapFrom(src => src.Client != null ? src.Client.Username : "Unknown"))
                .ForMember(dest => dest.CarRepairShop, opt => opt.MapFrom(src => src.CarRepairShop != null ? src.CarRepairShop.Username : "Unknown"));
        }
    }
}
