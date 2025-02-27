﻿using AutoMapper;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.OrderStateMachine
{
    public class MissingPaymentOrderState : BaseOrderState
    {
        public MissingPaymentOrderState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public async override Task<OrderGetDTO> AddSuccessfulPayment(Order entity, string paymentIntentId)
        {
            entity.State = "onhold";

            entity.PaymentIntentId = paymentIntentId;

            await _context.SaveChangesAsync();

            return _mapper.Map<OrderGetDTO>(entity);
        }

        public async override Task<OrderGetDTO> AddFailedPayment(Order entity, string paymentIntentId)
        {
            entity.State = "paymentfailed";

            entity.PaymentIntentId = paymentIntentId;

            await _context.SaveChangesAsync();

            return _mapper.Map<OrderGetDTO>(entity);
        }

        public override async Task<OrderGetDTO> SoftDelete(Order entity, string role)
        {
            if (role == "carpartsshop")
            {
                entity.DeletedByShop = true;
            }
            else if (role == "client" || role == "carrepairshop")
            {
                entity.DeletedByCustomer = true;
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<OrderGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("AddSuccessfulPayment");
            list.Add("AddFailedPayment");
            list.Add("SoftDelete");

            return list;
        }
    }
}
