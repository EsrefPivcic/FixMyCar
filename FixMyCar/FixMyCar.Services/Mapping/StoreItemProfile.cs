using AutoMapper;
using FixMyCar.Model.DTOs.CarModel;
using FixMyCar.Model.DTOs.StoreItem;
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
            CreateMap<StoreItemInsertDTO, StoreItem>()
                .ForMember(dest => dest.ImageData, opt => opt.MapFrom(src => src.ImageData != null ? Convert.FromBase64String(src.ImageData!) : null))
                .ForMember(dest => dest.Discount, opt => opt.MapFrom(src => src.Discount != null ? src.Discount : 0));
            CreateMap<StoreItemUpdateDTO, StoreItem>()
                .ForMember(dest => dest.ImageData, opt =>
                {
                    opt.MapFrom(src => Convert.FromBase64String(src.ImageData!));
                }).ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));
            CreateMap<StoreItemGetDTO, StoreItem>();
            CreateMap<StoreItem, StoreItemInsertDTO>();
            CreateMap<StoreItem, StoreItemUpdateDTO>();
            CreateMap<StoreItem, StoreItemGetDTO>()
                .ForMember(dest => dest.ImageData, opt =>
                    opt.MapFrom(src => src.ImageData != null ? Convert.ToBase64String(src.ImageData) : string.Empty))
                .ForMember(dest => dest.Category, opt => opt.MapFrom(src => src.StoreItemCategory != null ? src.StoreItemCategory.Name : string.Empty))
                .ForMember(dest => dest.CarModels, opt => opt.MapFrom(src => src.CarModels ?? null));
        }
    }
}