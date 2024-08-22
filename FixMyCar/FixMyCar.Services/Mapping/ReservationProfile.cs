using AutoMapper;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class ReservationProfile : Profile
    {
        public ReservationProfile()
        {
            CreateMap<ReservationUpdateDTO, Reservation>();
            CreateMap<ReservationInsertDTO, Reservation>()
                 .ForMember(dest => dest.ClientId, opt => opt.Ignore());
            CreateMap<Reservation, ReservationGetDTO>()
                .ForMember(dest => dest.ClientUsername, opt => opt.MapFrom(src => src.Client != null ? src.Client.Username : "Unknown"))
                .ForMember(dest => dest.CarRepairShopName, opt => opt.MapFrom(src => src.CarRepairShop != null ? src.CarRepairShop.Username : "Unknown"))
                .ForMember(dest => dest.CarRepairShopDiscountValue, opt => opt.MapFrom(src => src.CarRepairShopDiscount != null ? src.CarRepairShopDiscount.Value : 0));
        }
    }
}
