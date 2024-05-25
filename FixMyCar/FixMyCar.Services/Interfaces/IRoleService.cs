using FixMyCar.Model.DTOs.Role;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IRoleService : IBaseService<Role, RoleGetDTO, RoleInsertDTO, RoleUpdateDTO, RoleSearchObject>
    {
    }
}
