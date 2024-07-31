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
            CreateMap<CarRepairShopInsertDTO, CarRepairShop>();
            CreateMap<CarRepairShopUpdateDTO, CarRepairShop>()
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null)); ;
            CreateMap<CarRepairShop, CarRepairShopInsertDTO>();
            CreateMap<CarRepairShop, CarRepairShopUpdateDTO>();
            CreateMap<CarRepairShop, CarRepairShopGetDTO>()
                .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role.Name));
        }
    }
}
