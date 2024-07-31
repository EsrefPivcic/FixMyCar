using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.Admin;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class AdminController : BaseController<Admin, AdminGetDTO, AdminInsertDTO, AdminUpdateDTO, AdminSearchObject>
    {
        public AdminController(IAdminService service, ILogger<BaseController<Admin, AdminGetDTO, AdminInsertDTO, AdminUpdateDTO, AdminSearchObject>> logger) : base(service, logger)
        {
        }
    }
}
