using AutoMapper;
using FixMyCar.Model.DTOs.Admin;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace FixMyCar.Services.Mapping
{
    public class AdminProfile : Profile
    {
        public AdminProfile()
        {
            CreateMap<AdminInsertDTO, Admin>()
                .ForMember(dest => dest.Image, opt => opt.Ignore());
            CreateMap<AdminUpdateDTO, Admin>()
                .ForMember(dest => dest.Username, opt => opt.Ignore())
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));
            CreateMap<Admin, AdminInsertDTO>();
            CreateMap<Admin, AdminUpdateDTO>();
            CreateMap<Admin, AdminGetDTO>()
                .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role.Name))
                .ForMember(dest => dest.City, opt => opt.MapFrom(src => src.City.Name))
                .ForMember(dest => dest.Image, opt => opt.MapFrom(src => src.Image != null ? Convert.ToBase64String(src.Image) : string.Empty));
        }
    }
}
