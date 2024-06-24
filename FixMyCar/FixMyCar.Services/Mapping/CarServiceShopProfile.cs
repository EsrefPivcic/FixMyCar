using AutoMapper;
using FixMyCar.Model.DTOs.CarServiceShop;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class CarServiceShopProfile : Profile
    {
        public CarServiceShopProfile() {
            CreateMap<CarServiceShopInsertDTO, CarServiceShop>();
            CreateMap<CarServiceShopUpdateDTO, CarServiceShop>().ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null)); ;
            CreateMap<CarServiceShop, CarServiceShopInsertDTO>();
            CreateMap<CarServiceShop, CarServiceShopUpdateDTO>();
            CreateMap<CarServiceShop, CarServiceShopGetDTO>()
            .ForMember(dest => dest.CityName, opt => opt.MapFrom(src => src.City.Name)).ForMember(dest => dest.Logo, opt =>
                    opt.MapFrom(src => src.Logo != null ? Convert.ToBase64String(src.Logo) : string.Empty));
        }
    }
}
