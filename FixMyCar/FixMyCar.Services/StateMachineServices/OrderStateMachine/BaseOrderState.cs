using AutoMapper;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.StateMachineServices.StoreItemStateMachine;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.OrderStateMachine
{
    public class BaseOrderState
    {
        protected FixMyCarContext _context;
        protected IMapper _mapper;
        public IServiceProvider _serviceProvider;

        public BaseOrderState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual async Task<OrderGetDTO> Insert(OrderInsertDTO request)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<OrderGetDTO> Update(Order entity, OrderUpdateDTO request)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<OrderGetDTO> Accept(Order entity, OrderAcceptDTO orderAccept)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<OrderGetDTO> Reject(Order entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<OrderGetDTO> AddFailedPayment(Order entity, string paymentIntentId)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<OrderGetDTO> AddSuccessfulPayment(Order entity, string paymentIntentId)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<OrderGetDTO> Cancel(Order entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<OrderGetDTO> Resend(Order entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }

        public BaseOrderState CreateState(string state)
        {
            switch (state)
            {
                case "initial":
                case null:
                    return _serviceProvider.GetService<InitialOrderState>()!;
                case "awaitingpayment":
                    return _serviceProvider.GetService<AwaitingPaymentOrderState>()!;
                case "onhold":
                    return _serviceProvider.GetService<OnHoldOrderState>()!;
                case "accepted":
                    return _serviceProvider.GetService<AcceptedOrderState>()!;
                case "rejected":
                    return _serviceProvider.GetService<RejectedOrderState>()!;
                case "cancelled":
                    return _serviceProvider.GetService<CancelledOrderState>()!;
                case "paymentfailed":
                    return _serviceProvider.GetService<PaymentFailedOrderState>()!;

                default:
                    throw new UserException("Action not allowed.");
            }
        }
    }
}
