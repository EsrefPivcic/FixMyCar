﻿using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Data;
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
            return await (_service as IReservationService)!.Insert(request);
        }

        [HttpPut("AddOrder/{id}/{orderId}")]
        public virtual async Task<ReservationGetDTO> AddOrder(int id, int orderId)
        {
            string username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value!;
            return await (_service as IReservationService)!.AddOrder(id, orderId, username);
        }

        [HttpPut("Accept/{id}/{estimatedCompletionDate}")]
        public virtual async Task<ReservationGetDTO> Accept(int id, DateTime estimatedCompletionDate)
        {
            return await (_service as IReservationService)!.Accept(id, estimatedCompletionDate);
        }

        [HttpPut("Reject/{id}")]
        public virtual async Task<ReservationGetDTO> Reject(int id)
        {
            return await (_service as IReservationService)!.Reject(id);
        }

        [HttpPut("Cancel/{id}")]
        public virtual async Task<ReservationGetDTO> Cancel(int id)
        {
            return await (_service as IReservationService)!.Cancel(id);
        }

        [HttpPut("Resend/{id}")]
        public virtual async Task<ReservationGetDTO> Resend(int id)
        {
            return await (_service as IReservationService)!.Resend(id);
        }

        [HttpPut("Start/{id}")]
        public virtual async Task<ReservationGetDTO> Start(int id)
        {
            return await (_service as IReservationService)!.Start(id);
        }

        [HttpPut("UpdateEstimatedDate/{id}/{newEstimatedCompletion}")]
        public virtual async Task<ReservationGetDTO> UpdateEstimatedDate(int id, DateTime newEstimatedCompletion)
        {
            return await (_service as IReservationService)!.UpdateEstimatedDate(id, newEstimatedCompletion);
        }

        [HttpPut("Complete/{id}")]
        public virtual async Task<ReservationGetDTO> Complete(int id)
        {
            return await (_service as IReservationService)!.Complete(id);
        }

        [HttpPut("SoftDelete/{id}")]
        public virtual async Task<ReservationGetDTO> SoftDelete(int id)
        {
            string role = User.FindFirst(ClaimTypes.Role)?.Value!;
            return await (_service as IReservationService)!.SoftDelete(id, role);
        }

        [HttpGet("AllowedActions/{id}")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IReservationService)!.AllowedActions(id);
        }

        [HttpPut("AddFailedPayment/{id}/{paymentIntentId}")]
        public virtual async Task<ReservationGetDTO> AddFailedPayment(int id, string paymentIntentId)
        {
            return await (_service as IReservationService).AddFailedPayment(id, paymentIntentId);
        }

        [HttpPut("AddSuccessfulPayment/{id}/{paymentIntentId}")]
        public virtual async Task<ReservationGetDTO> AddSuccessfulPayment(int id, string paymentIntentId)
        {
            return await (_service as IReservationService).AddSuccessfulPayment(id, paymentIntentId);
        }

        [HttpGet("GetByCarRepairShop")]
        public async Task<PagedResult<ReservationGetDTO>> GetByCarRepairShop([FromQuery] ReservationSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.CarRepairShopName = username;
            return await (_service as IReservationService)!.Get(search);
        }

        [HttpGet("GetShopAvailability")]
        public async Task<List<ReservationAvailabilityDTO>> GetShopAvailability(int carRepairShopId)
        {
            return await (_service as IReservationService)!.GetShopAvailability(carRepairShopId);
        }

        [HttpGet("GetByClientToken")]
        public async Task<PagedResult<ReservationGetDTO>> GetByClient([FromQuery] ReservationSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.ClientUsername = username;
            return await (_service as IReservationService)!.Get(search);
        }
    }
}
