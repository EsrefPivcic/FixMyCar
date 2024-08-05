using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.OrderDetail;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class OrderDetailController : BaseController<OrderDetail, OrderDetailGetDTO, OrderDetailInsertDTO, OrderDetailUpdateDTO, OrderDetailSearchObject>
    {
        public OrderDetailController(IOrderDetailService service, ILogger<BaseController<OrderDetail, OrderDetailGetDTO, OrderDetailInsertDTO, OrderDetailUpdateDTO, OrderDetailSearchObject>> logger) : base(service, logger)
        {
        }
    }
}
