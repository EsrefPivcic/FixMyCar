using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class OrderController : BaseController<Order, OrderGetDTO, OrderInsertDTO, OrderUpdateDTO, OrderSearchObject>
    {
        public OrderController(IOrderService service, ILogger<BaseController<Order, OrderGetDTO, OrderInsertDTO, OrderUpdateDTO, OrderSearchObject>> logger) : base (service, logger)
        { 
        }

        [HttpPut("{id}/Accept")]
        public virtual async Task<OrderGetDTO> Accept(int id)
        {
            return await (_service as IOrderService).Accept(id);
        }

        [HttpPut("{id}/Reject")]
        public virtual async Task<OrderGetDTO> Reject(int id)
        {
            return await (_service as IOrderService).Reject(id);
        }

        [HttpPut("{id}/Cancel")]
        public virtual async Task<OrderGetDTO> Cancel(int id)
        {
            return await (_service as IOrderService).Cancel(id);
        }

        [HttpPut("{id}/Resend")]
        public virtual async Task<OrderGetDTO> Resend(int id)
        {
            return await (_service as IOrderService).Resend(id);
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IOrderService).AllowedActions(id);
        }
    }
}
