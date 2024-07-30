using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShop;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class CarRepairShopProfile : Profile
    {
        public CarRepairShopProfile() {
            /*CreateMap<CarRepairShopInsertDTO, CarRepairShop>();
            CreateMap<CarRepairShopUpdateDTO, CarRepairShop>().ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null)); ;
            CreateMap<CarRepairShop, CarRepairShopInsertDTO>();
            CreateMap<CarRepairShop, CarRepairShopUpdateDTO>();
            CreateMap<CarRepairShop, CarRepairShopGetDTO>()
            .ForMember(dest => dest.CityName, opt => opt.MapFrom(src => src.City.Name)).ForMember(dest => dest.Logo, opt =>
                    opt.MapFrom(src => src.Logo != null ? Convert.ToBase64String(src.Logo) : string.Empty));*/
        }
    }
}
