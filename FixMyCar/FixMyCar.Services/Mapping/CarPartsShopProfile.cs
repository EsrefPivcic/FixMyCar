using AutoMapper;
using FixMyCar.Model.DTOs.CarPartsShop;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class CarPartsShopProfile : Profile
    {
        public CarPartsShopProfile()
        {
            CreateMap<CarPartsShopInsertDTO, CarPartsShop>();
            CreateMap<CarPartsShopUpdateDTO, CarPartsShop>()
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null)); ;
            CreateMap<CarPartsShop, CarPartsShopInsertDTO>();
            CreateMap<CarPartsShop, CarPartsShopUpdateDTO>();
            CreateMap<CarPartsShop, CarPartsShopGetDTO>()
                .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role.Name));
        }
    }
}
