using AutoMapper;
using FixMyCar.Model.DTOs.Role;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class RoleProfile : Profile
    {
        public RoleProfile()
        {
            CreateMap<RoleInsertDTO, Role>();
            CreateMap<RoleUpdateDTO, Role>();
            CreateMap<RoleGetDTO, Role>();
            CreateMap<Role, RoleInsertDTO>();
            CreateMap<Role, RoleUpdateDTO>();
            CreateMap<Role, RoleGetDTO>();
        }
    }
}
