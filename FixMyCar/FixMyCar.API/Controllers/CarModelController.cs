using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.CarModel;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class CarModelController : BaseReadOnlyController<CarModel, CarModelGetDTO, CarModelSearchObject>
    {
        public CarModelController(ICarModelService service, ILogger<BaseReadOnlyController<CarModel, CarModelGetDTO, CarModelSearchObject>> logger) : base (logger, service) { }

        [HttpGet("/GetByManufacturerAll")]
        public virtual async Task<PagedResult<CarModelGetByManufacturerDTO>> GetByManufacturerAll()
        {
            return await (_service as ICarModelService).GetByManufacturerAll();
        }
    }
}
