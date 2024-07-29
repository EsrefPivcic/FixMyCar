using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.CarPartsShopClientDiscount;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class CarPartsShopClientDiscountController : BaseController<CarPartsShopClientDiscount, CarPartsShopClientDiscountGetDTO, CarPartsShopClientDiscountInsertDTO, CarPartsShopClientDiscountUpdateDTO, CarPartsShopClientDiscountSearchObject>
    {
        public CarPartsShopClientDiscountController(ICarPartsShopClientDiscountService service, ILogger<BaseController<CarPartsShopClientDiscount, CarPartsShopClientDiscountGetDTO, CarPartsShopClientDiscountInsertDTO, CarPartsShopClientDiscountUpdateDTO, CarPartsShopClientDiscountSearchObject>> logger) : base(service, logger)
        {
        }
    }
}
