using FixMyCar.Model.DTOs.AuthToken;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.DTOs.User;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Runtime.CompilerServices;

namespace FixMyCar.Controllers
{
    [ApiController]
    public class AuthController : ControllerBase
    {
        protected readonly ILogger<AuthController> _logger;
        protected readonly IAuthService _service;

        public AuthController(IAuthService service, ILogger<AuthController> logger)
        {
            _service = service;
            _logger = logger;
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] UserLoginDTO credentials)
        {
            var token = await (_service as IAuthService).Login(credentials.Username, credentials.Password, credentials.Role);

            if (token == null)
            {
                throw new UserException("Incorrect login!");
            }

            return Ok(new { token });
        }

        [HttpPost("logout")]
        public async Task<IActionResult> Logout()
        {
            var token = Request.Headers["Authorization"].ToString().Split(" ").Last();
            await (_service as IAuthService).RevokeToken(token);
            return Ok(new { message = "Logout successful." });
        }
    }
}