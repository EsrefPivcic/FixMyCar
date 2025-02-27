﻿using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.Admin;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace FixMyCar.API.Controllers
{
    [Authorize(Roles = "admin")]
    [ApiController]
    public class AdminController : BaseController<Admin, AdminGetDTO, AdminInsertDTO, AdminUpdateDTO, AdminSearchObject>
    {
        public AdminController(IAdminService service, ILogger<BaseController<Admin, AdminGetDTO, AdminInsertDTO, AdminUpdateDTO, AdminSearchObject>> logger) : base(service, logger)
        {
        }

        [HttpGet("GetByToken")]
        public async Task<PagedResult<AdminGetDTO>> GetByToken([FromQuery] AdminSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.Username = username;
            return await (_service as IAdminService).Get(search);
        }
    }
}
