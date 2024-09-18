using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Security.Claims;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class OrderController : BaseController<Order, OrderGetDTO, OrderInsertDTO, OrderUpdateDTO, OrderSearchObject>
    {
        public OrderController(IOrderService service, ILogger<BaseController<Order, OrderGetDTO, OrderInsertDTO, OrderUpdateDTO, OrderSearchObject>> logger) : base (service, logger)
        { 
        }

        [HttpPost()]
        public async override Task<OrderGetDTO> Insert(OrderInsertDTO request)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            request.Username = username;
            return await (_service as IOrderService).Insert(request);
        }

        [HttpPut("Accept/{id}")]
        public virtual async Task<OrderGetDTO> Accept(int id, OrderAcceptDTO orderAccept)
        {
            return await (_service as IOrderService).Accept(id, orderAccept);
        }

        [HttpPut("Reject/{id}")]
        public virtual async Task<OrderGetDTO> Reject(int id)
        {
            return await (_service as IOrderService).Reject(id);
        }

        [HttpPut("Cancel/{id}")]
        public virtual async Task<OrderGetDTO> Cancel(int id)
        {
            return await (_service as IOrderService).Cancel(id);
        }

        [HttpPut("Resend/{id}")]
        public virtual async Task<OrderGetDTO> Resend(int id)
        {
            return await (_service as IOrderService).Resend(id);
        }

        [HttpGet("AllowedActions/{id}")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IOrderService).AllowedActions(id);
        }

        [HttpGet("GetBasicOrderInfo/{id}")]
        public virtual async Task<OrderBasicInfoGetDTO> GetBasicOrderInfo(int id)
        {
            return await (_service as IOrderService).GetBasicOrderInfo(id);
        }

        [HttpGet("GetByCarPartsShop")]
        public async Task<PagedResult<OrderGetDTO>> GetByCarPartsShop([FromQuery] OrderSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.CarPartsShopName = username;
            return await (_service as IOrderService).Get(search);
        }

        [HttpGet("GetByCarRepairShop")]
        public async Task<PagedResult<OrderGetDTO>> GetByCarRepairShop([FromQuery] OrderSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.CarRepairShopName = username;
            search.Role = "carrepairshop";
            return await (_service as IOrderService).Get(search);
        }
    }
}