using AutoMapper;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.ReservationStateMachine
{
    public class BaseReservationState
    {
        protected FixMyCarContext _context;
        protected IMapper _mapper;
        public IServiceProvider _serviceProvider;

        public BaseReservationState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual async Task<ReservationGetDTO> Insert(ReservationInsertDTO request)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ReservationGetDTO> Update(Reservation entity, ReservationUpdateDTO request)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ReservationGetDTO> AddOrder(Reservation entity, int orderId, string username)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ReservationGetDTO> Accept(Reservation entity, DateTime estimatedCompletionDate)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ReservationGetDTO> Reject(Reservation entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ReservationGetDTO> AddFailedPayment(Reservation entity, string paymentIntentId)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ReservationGetDTO> AddSuccessfulPayment(Reservation entity, string paymentIntentId)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ReservationGetDTO> Cancel(Reservation entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ReservationGetDTO> Resend(Reservation entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ReservationGetDTO> Start(Reservation entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ReservationGetDTO> Complete(Reservation entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ReservationGetDTO> UpdateEstimatedDate(Reservation entity, DateTime newEstimatedCompletion)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }

        public BaseReservationState CreateState(string state)
        {
            return state switch
            {
                "initial" or null => _serviceProvider.GetService<InitialReservationState>()!,
                "missingpayment" => _serviceProvider.GetService<MissingPaymentReservationState>()!,
                "awaitingorder" => _serviceProvider.GetService<AwaitingOrderReservationState>()!,
                "orderpendingapproval" => _serviceProvider.GetService<OrderPendingApprovalReservationState>()!,
                "orderdateconflict" => _serviceProvider.GetService<OrderDateConflictReservationState>()!,
                "ready" => _serviceProvider.GetService<ReadyReservationState>()!,
                "accepted" => _serviceProvider.GetService<AcceptedReservationState>()!,
                "rejected" => _serviceProvider.GetService<RejectedReservationState>()!,
                "cancelled" => _serviceProvider.GetService<CancelledReservationState>()!,
                "ongoing" => _serviceProvider.GetService<OngoingReservationState>()!,
                "completed" => _serviceProvider.GetService<CompletedReservationState>()!,
                "paymentfailed" => _serviceProvider.GetService<PaymentFailedReservationState>()!,
                _ => throw new UserException("Action not allowed."),
            };
        }
    }
}
