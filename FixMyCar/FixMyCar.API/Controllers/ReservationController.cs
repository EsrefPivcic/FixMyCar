using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class ReservationController : BaseController<Reservation, ReservationGetDTO, ReservationInsertDTO, ReservationUpdateDTO, ReservationSearchObject>
    {
        public ReservationController(IReservationService service, ILogger<BaseController<Reservation, ReservationGetDTO, ReservationInsertDTO, ReservationUpdateDTO, ReservationSearchObject>> logger) : base(service, logger)
        {
        }

        [HttpPost()]
        public async override Task<ReservationGetDTO> Insert(ReservationInsertDTO request)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            request.ClientUsername = username;
            return await (_service as IReservationService).Insert(request);
        }

        [HttpPut("AddOrder/{id}")]
        public virtual async Task<ReservationGetDTO> AddOrder(int id, ReservationUpdateDTO request)
        {
            return await (_service as IReservationService).AddOrder(id, request);
        }

        [HttpPut("Accept/{id}")]
        public virtual async Task<ReservationGetDTO> Accept(int id)
        {
            return await (_service as IReservationService).Accept(id);
        }

        [HttpPut("Reject/{id}")]
        public virtual async Task<ReservationGetDTO> Reject(int id)
        {
            return await (_service as IReservationService).Reject(id);
        }

        [HttpPut("Cancel/{id}")]
        public virtual async Task<ReservationGetDTO> Cancel(int id)
        {
            return await (_service as IReservationService).Cancel(id);
        }

        [HttpPut("Resend/{id}")]
        public virtual async Task<ReservationGetDTO> Resend(int id)
        {
            return await (_service as IReservationService).Resend(id);
        }

        [HttpPut("Complete/{id}")]
        public virtual async Task<ReservationGetDTO> Complete(int id)
        {
            return await (_service as IReservationService).Complete(id);
        }

        [HttpGet("AllowedActions/{id}")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IReservationService).AllowedActions(id);
        }

        [HttpGet("GetByCarRepairShop")]
        public async Task<PagedResult<ReservationGetDTO>> GetByCarRepairShop([FromQuery] ReservationSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.CarRepairShopName = username;
            return await (_service as IReservationService).Get(search);
        }
    }
}
