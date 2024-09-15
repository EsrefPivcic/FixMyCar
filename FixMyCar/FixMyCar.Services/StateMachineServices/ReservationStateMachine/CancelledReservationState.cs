﻿using AutoMapper;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Utilities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

namespace FixMyCar.Services.StateMachineServices.ReservationStateMachine
{
    public class CancelledReservationState : BaseReservationState
    {
        public CancelledReservationState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<ReservationGetDTO> Update(Reservation entity, ReservationUpdateDTO request)
        {
            DateTime reservationDate = request.ReservationDate ?? entity.ReservationDate;

            var repairShop = await _context.Users.OfType<CarRepairShop>().FirstOrDefaultAsync(c => c.Id == entity.CarRepairShopId);

            if (request.ReservationDate != null)
            {
                bool isOnWorkDay = Validation.IsReservationOnWorkday(reservationDate, repairShop!);

                if (!isOnWorkDay)
                {
                    throw new UserException($"Can't make a reservation on a non-work day! ({reservationDate.DayOfWeek})");
                }

                var reservations = await _context.Reservations
                    .Where(r => r.ReservationDate.Date == reservationDate.Date && r.CarRepairShopId == entity.CarRepairShopId)
                    .Where(r => r.Id != entity.Id)
                    .ToListAsync();

                if (reservations != null)
                {
                    bool isWithinWorkHours = Validation.IsWithinWorkHours(entity.TotalDuration, repairShop!.WorkingHours, reservations);

                    if (!isWithinWorkHours)
                    {
                        throw new UserException($"You can't make a reservation on {reservationDate.Day}.{reservationDate.Month}.{reservationDate.Year}. since there is too many reservations on that day.");
                    }
                }

                if (entity.Type != "Diagnostics" && entity.OrderId != null)
                {
                    var order = await _context.Orders.FindAsync(entity.OrderId);

                    if (order!.State == "accepted" && request.ReservationDate < order!.ShippingDate)
                    {
                        throw new UserException("New reservation date must be the same as order shipping date or later.");
                    }
                }
            }

            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<ReservationGetDTO> Resend(Reservation entity)
        {
            if (entity.Type != "Diagnostics")
            {
                if (entity.OrderId != null)
                {
                    var order = await _context.Orders.FindAsync(entity.OrderId);

                    if (order!.State == "accepted" && entity.ReservationDate < order!.ShippingDate)
                    {
                        entity.State = "orderdateconflict";
                    }
                    else if (order!.State == "accepted" && entity.ReservationDate >= order!.ShippingDate)
                    {
                        entity.State = "ready";
                    }
                    else
                    {
                        entity.State = "orderpendingapproval";
                    }
                }
                else
                {
                    entity.State = "awaitingorder";
                }
            }
            else
            {
                entity.State = "ready";
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Resend");
            list.Add("Update");

            return list;
        }
    }
}
