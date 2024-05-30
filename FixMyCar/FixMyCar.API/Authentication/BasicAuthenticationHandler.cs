using FixMyCar.Model.DTOs.User;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;

namespace FixMyCar.Authentication
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        IUserService _userService;
        public BasicAuthenticationHandler(IOptionsMonitor<AuthenticationSchemeOptions> options, ILoggerFactory logger, UrlEncoder encoder, ISystemClock clock, IUserService userService) : base(options, logger, encoder, clock)
        {
            _userService = userService;
        }

        protected async override Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if(!Request.Headers.ContainsKey("Authorization"))
            {
                return AuthenticateResult.Fail("Missing header.");
            }

            var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
            var credentialsBytes = Convert.FromBase64String(authHeader.Parameter);
            var credentials = Encoding.UTF8.GetString(credentialsBytes).Split(':');

            var username = credentials[0];
            var password = credentials[1];

            UserGetDTO user = await _userService.Login(username, password);

            if (user == null)
            {
                return AuthenticateResult.Fail("Incorrect username or password.");
            }
            else
            {
                var claims = new List<Claim>()
                {
                    new Claim(ClaimTypes.Name, user.Name),
                    new Claim(ClaimTypes.NameIdentifier, user.Username),
                    new Claim(ClaimTypes.Role, user.Role.Name)
                };

                var identity = new ClaimsIdentity(claims, Scheme.Name);

                var principal = new ClaimsPrincipal(identity);

                var ticket = new AuthenticationTicket(principal, Scheme.Name);
                return AuthenticateResult.Success(ticket);
            }
        }
    }
}
