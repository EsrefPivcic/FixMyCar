using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.Client;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class ClientController : BaseController<Client, ClientGetDTO, ClientInsertDTO, ClientUpdateDTO, ClientSearchObject>
    {
        public ClientController(IClientService service, ILogger<BaseController<Client, ClientGetDTO, ClientInsertDTO, ClientUpdateDTO, ClientSearchObject>> logger) : base(service, logger)
        {
        }

        [AllowAnonymous]
        [HttpPost("InsertClient")]
        public async Task<ClientGetDTO> InsertClient(ClientInsertDTO request)
        {
            request.RoleId = 2;
            return await (_service as IClientService).Insert(request);
        }

        [HttpGet("GetByToken")]
        public async Task<PagedResult<ClientGetDTO>> GetByToken([FromQuery] ClientSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.Username = username;
            return await (_service as IClientService).Get(search);
        }
    }
}
