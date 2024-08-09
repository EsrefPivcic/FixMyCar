using FixMyCar.Model.DTOs.User;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace FixMyCar.Controllers
{
    [ApiController]
    public class UserController : BaseController<User, UserGetDTO, UserInsertDTO, UserUpdateDTO, UserSearchObject>
    {
        public UserController(IUserService service, ILogger<BaseController<User, UserGetDTO, UserInsertDTO, UserUpdateDTO, UserSearchObject>> logger) : base(service, logger)
        {
        }

        [HttpPost()]
        public async override Task<UserGetDTO> Insert(UserInsertDTO request)
        {
            request.RoleId = 0;
            return await (_service as IUserService).Insert(request);
        }

        [HttpPost("InsertAdmin")]
        public async Task<UserGetDTO> InsertAdmin(UserInsertDTO request)
        {
            request.RoleId = 1;
            return await (_service as IUserService).Insert(request);
        }

        [AllowAnonymous]
        [HttpPost("InsertCarPartsShop")]
        public async Task<UserGetDTO> InsertCarPartsShop(UserInsertDTO request)
        {
            request.RoleId = 4;
            return await (_service as IUserService).Insert(request);
        }

        [AllowAnonymous]
        [HttpPost("InsertCarRepairShop")]
        public async Task<UserGetDTO> InsertCarRepairShop(UserInsertDTO request)
        {
            request.RoleId = 3;
            return await (_service as IUserService).Insert(request);
        }

        [AllowAnonymous]
        [HttpPost("InsertClient")]
        public async Task<UserGetDTO> InsertClient(UserInsertDTO request)
        {
            request.RoleId = 2;
            return await (_service as IUserService).Insert(request);
        }

        [HttpGet("GetByToken")]
        public async Task<PagedResult<UserGetDTO>> GetByCarPartsShop([FromQuery] UserSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.Username = username;
            return await (_service as IUserService).Get(search);
        }
    }
}
