using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.CarRepairShopDiscount;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class CarRepairShopDiscountController : BaseController<CarRepairShopDiscount, CarRepairShopDiscountGetDTO, CarRepairShopDiscountInsertDTO, CarRepairShopDiscountUpdateDTO, CarRepairShopDiscountSearchObject>
    {
        public CarRepairShopDiscountController(ICarRepairShopDiscountService service, ILogger<BaseController<CarRepairShopDiscount, CarRepairShopDiscountGetDTO, CarRepairShopDiscountInsertDTO, CarRepairShopDiscountUpdateDTO, CarRepairShopDiscountSearchObject>> logger) : base(service, logger)
        {
        }

        [HttpPost()]
        public async override Task<CarRepairShopDiscountGetDTO> Insert(CarRepairShopDiscountInsertDTO request)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            request.CarRepairShopUsername = username;
            return await (_service as ICarRepairShopDiscountService).Insert(request);
        }

        [HttpGet("GetByCarRepairShop")]
        public async Task<PagedResult<CarRepairShopDiscountGetDTO>> GetByCarRepairShop([FromQuery] CarRepairShopDiscountSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            search.CarRepairShopName = username;

            return await (_service as ICarRepairShopDiscountService).Get(search);
        }
    }
}
