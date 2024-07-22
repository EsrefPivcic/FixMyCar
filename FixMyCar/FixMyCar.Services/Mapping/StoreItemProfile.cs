using AutoMapper;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class StoreItemProfile : Profile
    {
        public StoreItemProfile() 
        {
            CreateMap<StoreItemInsertDTO, StoreItem>();
            CreateMap<StoreItemUpdateDTO, StoreItem>()
                .ForMember(dest => dest.ImageData, opt =>
                {
                    opt.MapFrom(src => Convert.FromBase64String(src.ImageData));
                }).ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));
            CreateMap<StoreItemGetDTO, StoreItem>();
            CreateMap<StoreItem, StoreItemInsertDTO>();
            CreateMap<StoreItem, StoreItemUpdateDTO>();
            CreateMap<StoreItem, StoreItemGetDTO>()
                .ForMember(dest => dest.ImageData, opt =>
                    opt.MapFrom(src => src.ImageData != null ? Convert.ToBase64String(src.ImageData) : string.Empty))
                .ForMember(dest => dest.Category, opt => opt.MapFrom(src => src.StoreItemCategory.Name))
                .ForMember(dest => dest.CarModels, opt => opt.MapFrom(src => src.CarModels));
        }
    }
}