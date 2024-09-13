using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.CarRepairShop;
using FixMyCar.Model.DTOs.User;
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
    public class CarRepairShopController : BaseController<CarRepairShop, CarRepairShopGetDTO, CarRepairShopInsertDTO, CarRepairShopUpdateDTO, CarRepairShopSearchObject>
    {
        public CarRepairShopController(ICarRepairShopService service, ILogger<BaseController<CarRepairShop, CarRepairShopGetDTO, CarRepairShopInsertDTO, CarRepairShopUpdateDTO, CarRepairShopSearchObject>> logger) : base(service, logger)
        {
        }

        [AllowAnonymous]
        [HttpPost("InsertCarRepairShop")]
        public async Task<CarRepairShopGetDTO> InsertCarRepairShop(CarRepairShopInsertDTO request)
        {
            request.RoleId = 3;
            return await (_service as ICarRepairShopService).Insert(request);
        }

        [HttpPut("UpdateWorkDetailsByToken")]
        public async Task UpdateWorkDetails(CarRepairShopWorkDetailsUpdateDTO request)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            request.Username = username;
            await (_service as ICarRepairShopService).UpdateWorkDetails(request);
        }

        [HttpGet("GetByToken")]
        public async Task<PagedResult<CarRepairShopGetDTO>> GetByToken([FromQuery] CarRepairShopSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.Username = username;
            return await (_service as ICarRepairShopService).Get(search);
        }
    }
}
