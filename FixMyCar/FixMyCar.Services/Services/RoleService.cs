using AutoMapper;
using FixMyCar.Model.DTOs.Role;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class RoleService : BaseService<Role, RoleGetDTO, RoleInsertDTO, RoleUpdateDTO, RoleSearchObject>, IRoleService
    {
        public RoleService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
