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
            CreateMap<OrderInsertDTO, Order>();
            CreateMap<OrderUpdateDTO, Order>();
            CreateMap<Order, OrderInsertDTO>();
            CreateMap<Order, OrderUpdateDTO>();
            CreateMap<Order, OrderGetDTO>()
            .ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.User.Name))
            .ForMember(dest => dest.UserSurname, opt => opt.MapFrom(src => src.User.Surname))
            .ForMember(dest => dest.CarServiceShopName, opt => opt.MapFrom(src => src.CarServiceShop.Name))
            .ForMember(dest => dest.ClientDiscountValue, opt => opt.MapFrom(src => src.ClientDiscount != null ? src.ClientDiscount.Value : 0));
        }
    }
}
