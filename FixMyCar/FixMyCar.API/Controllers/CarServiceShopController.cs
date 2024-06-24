using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.CarServiceShop;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class CarServiceShopController : BaseController<CarServiceShop, CarServiceShopGetDTO, CarServiceShopInsertDTO, CarServiceShopUpdateDTO, CarServiceShopSearchObject>
    {
        public CarServiceShopController(ICarServiceShopService service, ILogger<BaseController<CarServiceShop, CarServiceShopGetDTO, CarServiceShopInsertDTO, CarServiceShopUpdateDTO, CarServiceShopSearchObject>> logger) : base(service, logger)
        {
        }
    }
}
