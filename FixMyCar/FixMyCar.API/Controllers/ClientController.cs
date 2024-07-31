using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.Client;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class ClientController : BaseController<Client, ClientGetDTO, ClientInsertDTO, ClientUpdateDTO, ClientSearchObject>
    {
        public ClientController(IClientService service, ILogger<BaseController<Client, ClientGetDTO, ClientInsertDTO, ClientUpdateDTO, ClientSearchObject>> logger) : base(service, logger)
        {
        }
    }
}
