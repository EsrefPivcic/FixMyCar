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
    }
}
