using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.CarRepairShopService;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace FixMyCar.API.Controllers
{
    public class CarRepairShopServiceController : BaseController<CarRepairShopService, CarRepairShopServiceGetDTO, CarRepairShopServiceInsertDTO, CarRepairShopServiceUpdateDTO, CarRepairShopServiceSearchObject>
    {
        public CarRepairShopServiceController(ICarRepairShopServiceService service, ILogger<BaseController<CarRepairShopService, CarRepairShopServiceGetDTO, CarRepairShopServiceInsertDTO, CarRepairShopServiceUpdateDTO, CarRepairShopServiceSearchObject>> logger) : base(service, logger)
        {
        }

        [HttpPost()]
        public async override Task<CarRepairShopServiceGetDTO> Insert([FromBody] CarRepairShopServiceInsertDTO request)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            request.CarRepairShopName = username;
            return await (_service as ICarRepairShopServiceService).Insert(request);
        }

        [HttpGet("GetByCarRepairShop")]
        public async Task<PagedResult<CarRepairShopServiceGetDTO>> GetByCarPartsShop([FromQuery] CarRepairShopServiceSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            search.CarRepairShopName = username;

            return await (_service as ICarRepairShopServiceService).Get(search);
        }

        [HttpPut("{id}/Activate")]
        public virtual async Task<CarRepairShopServiceGetDTO> Activate(int id)
        {
            return await (_service as ICarRepairShopServiceService).Activate(id);
        }

        [HttpPut("{id}/Hide")]
        public virtual async Task<CarRepairShopServiceGetDTO> Hide(int id)
        {
            return await (_service as ICarRepairShopServiceService).Hide(id);
        }

        [HttpGet("{id}/AllowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as ICarRepairShopServiceService).AllowedActions(id);
        }
    }
}
