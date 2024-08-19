using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.ServiceType;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class ServiceTypeController :BaseReadOnlyController<ServiceType, ServiceTypeGetDTO, ServiceTypeSearchObject>
    {
        public ServiceTypeController(IServiceTypeService service, ILogger<BaseReadOnlyController<ServiceType, ServiceTypeGetDTO, ServiceTypeSearchObject>> logger) : base(logger, service) { }
    }
}
