using AutoMapper;
using FixMyCar.Model.DTOs.User;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class UserProfile : Profile
    {
        public UserProfile()
        {
            CreateMap<UserInsertDTO, User>()
                .ForMember(dest => dest.Image, opt => opt.Ignore());
            CreateMap<UserUpdateDTO, User>()
                .ForMember(dest => dest.Username, opt => opt.Ignore())
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));
            CreateMap<UserGetDTO, User>();
            CreateMap<User, UserInsertDTO>();
            CreateMap<User, UserUpdateDTO>();
            CreateMap<User, UserGetDTO>()
                .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role.Name))
                .ForMember(dest => dest.City, opt => opt.MapFrom(src => src.City.Name))
                .ForMember(dest => dest.Image, opt => opt.MapFrom(src => src.Image != null ? Convert.ToBase64String(src.Image) : string.Empty));
            CreateMap<User, UserMinimalGetDTO>()
                .ForMember(dest => dest.Image, opt => opt.MapFrom(src => src.Image != null ? Convert.ToBase64String(src.Image) : string.Empty));
        }
    }
}
