﻿using AutoMapper;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.OrderStateMachine
{
    public class OnHoldOrderState : BaseOrderState
    {
        public OnHoldOrderState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public async override Task<OrderGetDTO> Update (Order entity, OrderUpdateDTO request)
        {
            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<OrderGetDTO>(entity);
        }

        public async override Task<OrderGetDTO> Accept(Order entity, OrderAcceptDTO orderAccept)
        {
            entity.State = "accepted";

            entity.ShippingDate = orderAccept.shippingDate;

            var reservation = await _context.Reservations.FirstOrDefaultAsync(r => r.OrderId == entity.Id);

            if (reservation != null) 
            {
                if (entity.ShippingDate > reservation.ReservationDate)
                {
                    reservation.State = "orderdateconflict";
                }
                else
                {
                    reservation.State = "ready";
                }
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<OrderGetDTO>(entity);
        }

        public async override Task<OrderGetDTO> Reject(Order entity)
        {
            entity.State = "rejected";

            var reservation = await _context.Reservations.FirstOrDefaultAsync(r => r.OrderId == entity.Id);

            if (reservation != null)
            {
                reservation.OrderId = null;
                reservation.State = "awaitingorder";
            }

            await _context.SaveChangesAsync();

            await _serviceProvider.GetRequiredService<IStripeService>().CreateRefundAsync(entity.PaymentIntentId!);

            return _mapper.Map<OrderGetDTO>(entity);
        }

        public async override Task<OrderGetDTO> Cancel(Order entity)
        {
            entity.State = "cancelled";

            var reservation = await _context.Reservations.FirstOrDefaultAsync(r => r.OrderId == entity.Id);

            if (reservation != null)
            {
                reservation.OrderId = null;
                reservation.State = "awaitingorder";
            }

            await _context.SaveChangesAsync();

            await _serviceProvider.GetRequiredService<IStripeService>().CreateRefundAsync(entity.PaymentIntentId!);

            return _mapper.Map<OrderGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Update");
            list.Add("Accept");
            list.Add("Reject");
            list.Add("Cancel");

            return list;
        }
    }
}
