using AutoMapper;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.StateMachineServices.ProductStateMachine;
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

        public virtual async Task<OrderGetDTO> Accept(Order entity, DateTime shippingDate)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<OrderGetDTO> Reject(Order entity)
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
                    return _serviceProvider.GetService<InitialOrderState>();
                    break;
                case "onhold":
                    return _serviceProvider.GetService<OnHoldOrderState>();
                    break;
                case "accepted":
                    return _serviceProvider.GetService<AcceptedOrderState>();
                    break;
                case "rejected":
                    return _serviceProvider.GetService<RejectedOrderState>();
                    break;
                case "cancelled":
                    return _serviceProvider.GetService<CancelledOrderState>();
                    break;

                default:
                    throw new UserException("Action not allowed.");
            }
        }
    }
}
