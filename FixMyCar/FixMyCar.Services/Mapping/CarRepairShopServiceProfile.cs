using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShopService;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace FixMyCar.Services.Mapping
{
    public class CarRepairShopServiceProfile : Profile
    {
        public CarRepairShopServiceProfile() {
            CreateMap<CarRepairShopServiceInsertDTO, CarRepairShopService>()
                .ForMember(dest => dest.ImageData, opt => opt.Ignore())
                .ForMember(dest => dest.Discount, opt => opt.MapFrom(src => src.Discount != null ? src.Discount : 0))
                .ForMember(dest => dest.Duration, opt => opt.MapFrom(src => src.Duration != null ? XmlConvert.ToTimeSpan(src.Duration) : TimeSpan.Zero));
            CreateMap<CarRepairShopServiceUpdateDTO, CarRepairShopService>()
                .ForMember(dest => dest.ImageData, opt => opt.Ignore())
                .ForMember(dest => dest.Discount, opt => opt.MapFrom(src => src.Discount != null ? src.Discount : 0))
                .ForMember(dest => dest.Duration, opt => opt.MapFrom(src => src.Duration != null ? XmlConvert.ToTimeSpan(src.Duration) : TimeSpan.Zero))
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));
                
            CreateMap<CarRepairShopService, CarRepairShopServiceGetDTO>()
                .ForMember(dest => dest.ImageData, opt =>
                    opt.MapFrom(src => src.ImageData != null ? Convert.ToBase64String(src.ImageData) : string.Empty))
                .ForMember(dest => dest.CarRepairShopName, opt => opt.MapFrom(src => src.CarRepairShop != null ? src.CarRepairShop.Username : string.Empty))
                .ForMember(dest => dest.ServiceTypeName, opt => opt.MapFrom(src => src.ServiceType != null ? src.ServiceType.Name : string.Empty));
        }
    }
}
