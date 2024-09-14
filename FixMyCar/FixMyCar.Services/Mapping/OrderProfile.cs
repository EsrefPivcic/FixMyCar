using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;

namespace FixMyCar.Services.Mapping
{
    public class OrderProfile : Profile
    {
        public OrderProfile() {
            CreateMap<OrderUpdateDTO, Order>()
                .ForMember(dest => dest.CityId, opt => opt.Ignore())
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));
            CreateMap<Order, OrderGetDTO>()
                .ForMember(dest => dest.Username, opt => opt.MapFrom(src => src.Client != null ? src.Client.Username : src.CarRepairShop != null ? src.CarRepairShop.Username : "Unknown"))
                .ForMember(dest => dest.ClientDiscountValue, opt => opt.MapFrom(src => src.ClientDiscount != null ? src.ClientDiscount.Value : 0))
                .ForMember(dest => dest.CarPartsShopName, opt => opt.MapFrom(src => src.CarPartsShop != null ? src.CarPartsShop.Username : "Unknown"))
                .ForMember(dest => dest.ShippingCity, opt => opt.MapFrom(src => src.City != null ? src.City.Name : "Unknown"));
            CreateMap<Order, OrderBasicInfoGetDTO>()
                .ForMember(dest => dest.Username, opt => opt.MapFrom(src => src.Client != null ? src.Client.Username : src.CarRepairShop != null ? src.CarRepairShop.Username : "Unknown"))
                .ForMember(dest => dest.CarPartsShopName, opt => opt.MapFrom(src => src.CarPartsShop != null ? src.CarPartsShop.Username : "Unknown"))
                .ForMember(dest => dest.Items, opt => opt.Ignore());
        }
    }
}
