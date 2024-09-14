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

namespace FixMyCar.Services.StateMachineServices.ReservationStateMachine
{
    public class AwaitingOrderReservationState : BaseReservationState
    {
        public AwaitingOrderReservationState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<ReservationGetDTO> AddOrder(Reservation entity, int orderId, string username)
        {
            var order = await _context.Orders.Include("CarRepairShop").Include("Client")
                .FirstOrDefaultAsync(x => x.Id == orderId) ??
                throw new UserException($"Order #{orderId} doesn't exist!");

            if (order.CarRepairShop != null)
            {
                if (order.CarRepairShop.Username != username)
                {
                    throw new UserException($"Order #{orderId} is not made by {username}!");
                }
            }

            if (order.Client != null)
            {
                if (order.Client.Username != username)
                {
                    throw new UserException($"Order #{orderId} is not made by {username}!");
                }
            }

            var alreadyUsed = await _context.Reservations.FirstOrDefaultAsync(x => x.OrderId == orderId);

            if (alreadyUsed != null) 
            {
                throw new UserException($"This order is already used for reservation #{alreadyUsed.Id}.");
            }

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == username) ?? throw new UserException("User not found");

            if ((entity.ClientOrder == true && user is Client) || (entity.ClientOrder == false && user is CarRepairShop))
            {
                if (order!.State == "accepted")
                {
                    entity.State = "ready";
                }
                else if (order!.State == "onhold")
                {
                    entity.State = "orderpendingapproval";
                }
                else
                {
                    throw new UserException($"Invalid order state ({order.State})! Please verify your order is either accepted or on hold!");
                }

                entity.OrderId = order.Id;

                await _context.SaveChangesAsync();

                return _mapper.Map<ReservationGetDTO>(entity);
            }
            else
            {
                throw new UserException("Not allowed!");
            }
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
            }

            if (request.Services != null)
            {
                bool repairs = false;
                bool diagnostics = false;

                TimeSpan totalDuration = TimeSpan.Zero;

                foreach (var serviceId in request.Services)
                {
                    var service = await _context.CarRepairShopServices.Include("ServiceType").FirstOrDefaultAsync(s => s.Id == serviceId) ?? throw new UserException($"Repair shop service #{serviceId} not found");
                    if (service.State != "active")
                    {
                        throw new UserException($"Can't make a reservation with inactive repair shop service (#{service.Id} - {service.Name}).");
                    }
                    totalDuration += service.Duration;

                    if (service.ServiceType.Name == "Repairs")
                    {
                        repairs = true;
                    }
                    else
                    {
                        diagnostics = true;
                    }
                }

                if (repairs)
                {
                    if (diagnostics)
                    {
                        entity.Type = "Repairs and Diagnostics";
                    }
                    else
                    {
                        entity.Type = "Repairs";
                    }
                }
                else
                {
                    entity.Type = "Diagnostics";
                    entity.State = "ready";
                }

                    var reservations = await _context.Reservations
                    .Where(r => r.ReservationDate.Date == reservationDate.Date && r.CarRepairShopId == entity.CarRepairShopId)
                    .Where(r => r.Id != entity.Id)
                    .ToListAsync();
                
                if (reservations != null)
                {
                    bool isWithinWorkHours = Validation.IsWithinWorkHours(totalDuration, repairShop!.WorkingHours, reservations);

                    if (!isWithinWorkHours)
                    {
                        throw new UserException($"You can't make a reservation on {reservationDate.Day}.{reservationDate.Month}.{reservationDate.Year}. since there is too many reservations on that day.");
                    }
                }
            }

            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<ReservationGetDTO> Reject(Reservation entity)
        {
            entity.State = "rejected";

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<ReservationGetDTO> Cancel(Reservation entity)
        {
            entity.State = "cancelled";

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("AddOrder");
            list.Add("Update");
            list.Add("Reject");
            list.Add("Cancel");

            return list;
        }
    }
}
