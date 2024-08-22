using AutoMapper;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.StateMachineServices.OrderStateMachine;
using FixMyCar.Services.StateMachineServices.ReservationStateMachine;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class ReservationService : BaseService<Reservation, ReservationGetDTO, ReservationInsertDTO, ReservationUpdateDTO, ReservationSearchObject>, IReservationService
    {
        BaseReservationState _baseReservationState;
        public ReservationService(FixMyCarContext context, IMapper mapper, BaseReservationState baseReservationState) : base(context, mapper)
        {
            _baseReservationState = baseReservationState;
        }

        public override IQueryable<Reservation> AddInclude(IQueryable<Reservation> query, ReservationSearchObject? search = null) 
        {
            query = query.Include("CarRepairShop");
            query = query.Include("Client");
            query = query.Include("CarRepairShopDiscount");
            return base.AddInclude(query, search);
        }

        public override IQueryable<Reservation> AddFilter(IQueryable<Reservation> query, ReservationSearchObject? search = null)
        {
            if (search != null)
            {
                if (search?.CarRepairShopName != null)
                {
                    query = query.Where(x => x.CarRepairShop.Name == search.CarRepairShopName);
                }

                if (search?.Discount != null)
                {
                    if (search.Discount == true)
                    {
                        query = query.Where(x => x.CarRepairShopDiscountId != null);
                    }
                    else
                    {
                        query = query.Where(x => x.CarRepairShopDiscountId == null);
                    }
                }

                if (!string.IsNullOrEmpty(search?.State))
                {
                    query = query.Where(x => x.State.Contains(search.State));

                    if (search?.State == "completed" && (search.MinCompletionDate != null || search?.MaxCompletionDate != null))
                    {
                        if (search?.MinCompletionDate != null && search?.MaxCompletionDate != null)
                        {
                            query = query.Where(x => x.CompletionDate >= search.MinCompletionDate && x.CompletionDate <= search.MaxCompletionDate);
                        }

                        if (search?.MinCompletionDate != null && search?.MaxCompletionDate == null)
                        {
                            query = query.Where(x => x.CompletionDate >= search.MinCompletionDate);
                        }

                        if (search?.MinCompletionDate == null && search?.MaxCompletionDate != null)
                        {
                            query = query.Where(x => x.CompletionDate <= search.MaxCompletionDate);
                        }
                    }
                }

                if (search?.MinTotalAmount != null && search?.MaxTotalAmount != null)
                {
                    query = query.Where(x => x.TotalAmount >= search.MinTotalAmount && x.TotalAmount <= search.MaxTotalAmount);
                }

                if (search?.MinTotalAmount != null && search?.MaxTotalAmount == null)
                {
                    query = query.Where(x => x.TotalAmount >= search.MinTotalAmount);
                }

                if (search?.MinTotalAmount == null && search?.MaxTotalAmount != null)
                {
                    query = query.Where(x => x.TotalAmount <= search.MaxTotalAmount);
                }

                if (search?.MinReservationDate != null && search?.MaxReservationDate != null)
                {
                    query = query.Where(x => x.ReservationDate >= search.MinReservationDate && x.ReservationDate <= search.MaxReservationDate);
                }

                if (search?.MinReservationDate != null && search?.MaxReservationDate == null)
                {
                    query = query.Where(x => x.ReservationDate >= search.MinReservationDate);
                }

                if (search?.MinReservationDate == null && search?.MaxReservationDate != null)
                {
                    query = query.Where(x => x.ReservationDate <= search.MaxReservationDate);
                }

                if (search?.MinCreatedDate != null && search?.MaxCreatedDate != null)
                {
                    query = query.Where(x => x.ReservationCreatedDate >= search.MinCreatedDate && x.ReservationCreatedDate <= search.MaxCreatedDate);
                }

                if (search?.MinCreatedDate != null && search?.MaxCreatedDate == null)
                {
                    query = query.Where(x => x.ReservationCreatedDate >= search.MinCreatedDate);
                }

                if (search?.MinCreatedDate == null && search?.MaxCreatedDate != null)
                {
                    query = query.Where(x => x.ReservationCreatedDate <= search.MaxCreatedDate);
                }
            }
            return base.AddFilter(query, search);
        }

        public override async Task<ReservationGetDTO> Insert(ReservationInsertDTO request)
        {
            var state = _baseReservationState.CreateState("initial");

            return await state.Insert(request);
        }

        public override async Task<ReservationGetDTO> Update(int id, ReservationUpdateDTO request)
        {
            var entity = await _context.Reservations.FindAsync(id);

            var state = _baseReservationState.CreateState(entity.State);

            return await state.Update(entity, request);
        }

        public async Task<ReservationGetDTO> AddOrder(int id, ReservationUpdateDTO request)
        {
            var entity = await _context.Reservations.FindAsync(id);

            var state = _baseReservationState.CreateState(entity.State);

            return await state.AddOrder(entity, request);
        }

        public async Task<ReservationGetDTO> Accept(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);

            var state = _baseReservationState.CreateState(entity.State);

            return await state.Accept(entity);
        }

        public async Task<ReservationGetDTO> Reject(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);

            var state = _baseReservationState.CreateState(entity.State);

            return await state.Reject(entity);
        }

        public async Task<ReservationGetDTO> Cancel(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);

            var state = _baseReservationState.CreateState(entity.State);

            return await state.Cancel(entity);
        }

        public async Task<ReservationGetDTO> Resend(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);

            var state = _baseReservationState.CreateState(entity.State);

            return await state.Resend(entity);
        }

        public async Task<ReservationGetDTO> Complete(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);

            var state = _baseReservationState.CreateState(entity.State);

            return await state.Complete(entity);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);
            var state = _baseReservationState.CreateState(entity?.State ?? "initial");
            return await state.AllowedActions();
        }
    }
}
