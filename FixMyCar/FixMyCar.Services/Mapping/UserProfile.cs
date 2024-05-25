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
            CreateMap<UserInsertDTO, User>();
            CreateMap<UserUpdateDTO, User>();
            CreateMap<UserGetDTO, User>();
            CreateMap<User, UserInsertDTO>();
            CreateMap<User, UserUpdateDTO>();
            CreateMap<User, UserGetDTO>();
        }
    }
}
