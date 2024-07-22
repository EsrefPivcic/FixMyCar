using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.CarRepairShop;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class CarRepairShopController : BaseController<CarRepairShop, CarRepairShopGetDTO, CarRepairShopInsertDTO, CarRepairShopUpdateDTO, CarRepairShopSearchObject>
    {
        public CarRepairShopController(ICarRepairShopService service, ILogger<BaseController<CarRepairShop, CarRepairShopGetDTO, CarRepairShopInsertDTO, CarRepairShopUpdateDTO, CarRepairShopSearchObject>> logger) : base(service, logger)
        {
        }
    }
}
