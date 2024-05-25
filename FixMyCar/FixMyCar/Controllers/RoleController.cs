using FixMyCar.Model.DTOs.Role;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.Controllers
{
    [ApiController]
    public class RoleController : BaseController<Role, RoleGetDTO, RoleInsertDTO, RoleUpdateDTO, RoleSearchObject>
    {
        public RoleController(IRoleService service, ILogger<BaseController<Role, RoleGetDTO, RoleInsertDTO, RoleUpdateDTO, RoleSearchObject>> logger) : base(service, logger)
        {
        }
    }
}
