using AutoMapper;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using Stripe.Forwarding;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.ReservationStateMachine
{
    public class MissingPaymentReservationState : BaseReservationState
    {
        public MissingPaymentReservationState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public async override Task<ReservationGetDTO> AddSuccessfulPayment(Reservation entity, string paymentIntentId)
        {
            if (entity.Type != "Diagnostics")
            {
                if (entity.OrderId == null)
                {
                    entity.State = "awaitingorder";
                }
                else
                {
                    var order = await _context.Orders.FindAsync(entity.OrderId);
                    if (order!.State == "accepted")
                    {
                        if (order.ShippingDate > entity.ReservationDate)
                        {
                            entity.State = "orderdateconflict";
                        }
                        else
                        {
                            entity.State = "ready";
                        }
                    }
                    else if (order!.State == "onhold")
                    {
                        entity.State = "orderpendingapproval";
                    }
                    else
                    {
                        throw new UserException($"Invalid order state ({order.State})! Please verify your order is either accepted or on hold!");
                    }
                }
            }
            else
            {
                entity.State = "ready";
            }

            entity.PaymentIntentId = paymentIntentId;

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public async override Task<ReservationGetDTO> AddFailedPayment(Reservation entity, string paymentIntentId)
        {
            entity.State = "paymentfailed";

            entity.PaymentIntentId = paymentIntentId;

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<ReservationGetDTO> SoftDelete(Reservation entity, string role)
        {
            if (role == "carrepairshop")
            {
                entity.DeletedByShop = true;
            }
            else if (role == "client")
            {
                entity.DeletedByCustomer = true;
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
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
