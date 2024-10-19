using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.City;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [AllowAnonymous]
    [ApiController]
    public class CityController : BaseController<City, CityGetDTO, CityInsertDTO, CityUpdateDTO, CitySearchObject>
    {
        public CityController(ICityService service, ILogger<BaseController<City, CityGetDTO, CityInsertDTO, CityUpdateDTO, CitySearchObject>> logger) : base(service, logger)
        {
        }
    }
}
