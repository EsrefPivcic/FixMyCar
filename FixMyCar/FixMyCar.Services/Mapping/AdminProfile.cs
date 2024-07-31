using AutoMapper;
using FixMyCar.Model.DTOs.Admin;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class AdminProfile : Profile
    {
        public AdminProfile()
        {
            CreateMap<AdminInsertDTO, Admin>();
            CreateMap<AdminUpdateDTO, Admin>()
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null)); ;
            CreateMap<Admin, AdminInsertDTO>();
            CreateMap<Admin, AdminUpdateDTO>();
            CreateMap<Admin, AdminGetDTO>()
                .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role.Name));
        }
    }
}
