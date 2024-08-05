using AutoMapper;
using FixMyCar.Model.DTOs.OrderDetail;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class OrderDetailProfile : Profile
    {
        public OrderDetailProfile() 
        {
            CreateMap<OrderDetailInsertDTO, OrderDetail>();
            CreateMap<OrderDetailUpdateDTO, OrderDetail>();
            CreateMap<OrderDetailGetDTO, OrderDetail>();
            CreateMap<OrderDetail, OrderDetailInsertDTO>();
            CreateMap<OrderDetail, OrderDetailUpdateDTO>();
            CreateMap<OrderDetail, OrderDetailGetDTO>()
                .ForMember(dest => dest.StoreItemName, opt => opt.MapFrom(src => src.StoreItem != null ? src.StoreItem.Name : "Unknown"));
        }
    }
}
