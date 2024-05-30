using FixMyCar.Model.DTOs.User;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.Controllers
{
    [ApiController]
    public class UserController : BaseController<User, UserGetDTO, UserInsertDTO, UserUpdateDTO, UserSearchObject>
    {
        public UserController(IUserService service, ILogger<BaseController<User, UserGetDTO, UserInsertDTO, UserUpdateDTO, UserSearchObject>> logger) : base(service, logger)
        {
        }

        [HttpPost("login")]
        [AllowAnonymous]
        public virtual async Task<UserGetDTO> Login(string username, string password)
        {
            return await (_service as IUserService).Login(username, password);
        }
    }
}
