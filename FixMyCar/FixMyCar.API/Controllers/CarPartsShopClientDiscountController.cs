using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.CarPartsShopClientDiscount;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class CarPartsShopClientDiscountController : BaseController<CarPartsShopClientDiscount, CarPartsShopClientDiscountGetDTO, CarPartsShopClientDiscountInsertDTO, CarPartsShopClientDiscountUpdateDTO, CarPartsShopClientDiscountSearchObject>
    {
        public CarPartsShopClientDiscountController(ICarPartsShopClientDiscountService service, ILogger<BaseController<CarPartsShopClientDiscount, CarPartsShopClientDiscountGetDTO, CarPartsShopClientDiscountInsertDTO, CarPartsShopClientDiscountUpdateDTO, CarPartsShopClientDiscountSearchObject>> logger) : base(service, logger)
        {
        }

        [HttpPost()]
        public async override Task<CarPartsShopClientDiscountGetDTO> Insert(CarPartsShopClientDiscountInsertDTO request)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            request.CarPartsShopUsername = username;
            return await (_service as ICarPartsShopClientDiscountService).Insert(request);
        }

        [HttpGet("GetByCarPartsShop")]
        public async Task<PagedResult<CarPartsShopClientDiscountGetDTO>> GetByCarPartsShop([FromQuery] CarPartsShopClientDiscountSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.CarPartsShopName = username;
            return await (_service as ICarPartsShopClientDiscountService).Get(search);
        }

        [HttpPut("SoftDelete/{id}")]
        public async Task SoftDelete(int id)
        {
            await (_service as ICarPartsShopClientDiscountService).SoftDelete(id);
        }

        [HttpGet("GetByClient")]
        public async Task<PagedResult<CarPartsShopClientDiscountGetDTO>> GetByClient([FromQuery] CarPartsShopClientDiscountSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.Username = username;
            return await (_service as ICarPartsShopClientDiscountService).Get(search);
        }
    }
}
