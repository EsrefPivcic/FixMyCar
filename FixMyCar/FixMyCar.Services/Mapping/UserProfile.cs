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
                .ForMember(dest => dest.Image, opt => opt.MapFrom(src => src.Image != null ? Convert.FromBase64String(src.Image!) : null));
            CreateMap<UserUpdateDTO, User>();
            CreateMap<UserGetDTO, User>();
            CreateMap<User, UserInsertDTO>();
            CreateMap<User, UserUpdateDTO>();
            CreateMap<User, UserGetDTO>()
                .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role.Name))
                .ForMember(dest => dest.City, opt => opt.MapFrom(src => src.City.Name))
                .ForMember(dest => dest.Image, opt => opt.MapFrom(src => src.Image != null ? Convert.ToBase64String(src.Image) : string.Empty));
        }
    }
}
