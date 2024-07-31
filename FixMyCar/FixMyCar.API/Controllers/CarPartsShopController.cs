using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.CarPartsShop;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class CarPartsShopController : BaseController<CarPartsShop, CarPartsShopGetDTO, CarPartsShopInsertDTO, CarPartsShopUpdateDTO, CarPartsShopSearchObject>
    {
        public CarPartsShopController(ICarPartsShopService service, ILogger<BaseController<CarPartsShop, CarPartsShopGetDTO, CarPartsShopInsertDTO, CarPartsShopUpdateDTO, CarPartsShopSearchObject>> logger) : base(service, logger)
        {
        }
    }
}
