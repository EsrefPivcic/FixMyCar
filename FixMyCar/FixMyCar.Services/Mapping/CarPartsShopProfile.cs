﻿using AutoMapper;
using FixMyCar.Model.DTOs.CarPartsShop;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace FixMyCar.Services.Mapping
{
    public class CarPartsShopProfile : Profile
    {
        public CarPartsShopProfile()
        {
            CreateMap<CarPartsShopInsertDTO, CarPartsShop>()
                .ForMember(dest => dest.WorkDays, opt => opt.MapFrom(src => src.WorkDays))
                 .ForMember(dest => dest.WorkDaysAsString, opt => opt.Ignore())
                .ForMember(dest => dest.Image, opt => opt.Ignore())
                .ForMember(dest => dest.OpeningTime, opt => opt.MapFrom(src => src.OpeningTime != null ? XmlConvert.ToTimeSpan(src.OpeningTime) : TimeSpan.Zero))
                .ForMember(dest => dest.ClosingTime, opt => opt.MapFrom(src => src.ClosingTime != null ? XmlConvert.ToTimeSpan(src.ClosingTime) : TimeSpan.Zero));
            CreateMap<CarPartsShopUpdateDTO, CarPartsShop>()
                .ForMember(dest => dest.Username, opt => opt.Ignore())
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));
            CreateMap<CarPartsShop, CarPartsShopInsertDTO>();
            CreateMap<CarPartsShop, CarPartsShopUpdateDTO>();
            CreateMap<CarPartsShop, CarPartsShopGetDTO>()
                .ForMember(dest => dest.WorkDays, opt => opt.MapFrom(src => src.WorkDays.Select(d => d.ToString()).ToList()))
                .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role.Name))
                .ForMember(dest => dest.City, opt => opt.MapFrom(src => src.City.Name))
                .ForMember(dest => dest.Image, opt => opt.MapFrom(src => src.Image != null ? Convert.ToBase64String(src.Image) : string.Empty));
        }
    }
}
