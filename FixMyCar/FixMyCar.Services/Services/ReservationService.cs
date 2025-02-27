﻿using AutoMapper;
using AutoMapper.Execution;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.StateMachineServices.ReservationStateMachine;
using Microsoft.EntityFrameworkCore;

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
            query = query.Include(r => r.CarModel).ThenInclude(cm => cm.CarManufacturer);
            return base.AddInclude(query, search);
        }

        public override IQueryable<Reservation> AddFilter(IQueryable<Reservation> query, ReservationSearchObject? search = null)
        {
            query = query.OrderByDescending(r => r.Id);

            if (search != null)
            {
                if (search?.CarRepairShopName != null)
                {
                    query = query.Where(x => x.CarRepairShop.Username == search.CarRepairShopName);
                    query = query.Where(x => x.DeletedByShop != true);
                }

                if (search?.ClientUsername != null)
                {
                    query = query.Where(x => x.Client.Username == search.ClientUsername);
                    query = query.Where(x => x.DeletedByCustomer != true);
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

                if (search?.ClientOrder != null)
                {
                    query = query.Where(x => x.ClientOrder == search.ClientOrder);
                }

                if (!string.IsNullOrEmpty(search?.Type))
                {
                    query = query.Where(x => x.Type.Contains(search.Type));
                }

                if (!string.IsNullOrEmpty(search?.State))
                {
                    query = query.Where(x => x.State.Contains(search.State));

                    if ((search?.State == "accepted" || search?.State == "ongoing" || search?.State == "completed") && (search.MinEstimatedCompletionDate != null || search?.MaxEstimatedCompletionDate != null))
                    {
                        if (search?.MinEstimatedCompletionDate != null && search?.MaxEstimatedCompletionDate != null)
                        {
                            query = query.Where(x => x.CompletionDate >= search.MinEstimatedCompletionDate && x.CompletionDate <= search.MaxEstimatedCompletionDate);
                        }

                        if (search?.MinEstimatedCompletionDate != null && search?.MaxEstimatedCompletionDate == null)
                        {
                            query = query.Where(x => x.CompletionDate >= search.MinEstimatedCompletionDate);
                        }

                        if (search?.MinEstimatedCompletionDate == null && search?.MaxEstimatedCompletionDate != null)
                        {
                            query = query.Where(x => x.CompletionDate <= search.MaxEstimatedCompletionDate);
                        }
                    }

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

        public async Task<List<ReservationAvailabilityDTO>> GetShopAvailability(int carRepairShopId)
        {
            var repairShopSet = _context.Set<CarRepairShop>();
            var shop = await repairShopSet.FindAsync(carRepairShopId);

            if (shop != null)
            {
                var reservations = await _context.Reservations
                    .Where(r => r.CarRepairShopId == carRepairShopId && r.ReservationDate.Date > DateTime.Now.Date && r.State == "accepted")
                    .ToListAsync();

                TimeSpan totalWorkingTime = shop.WorkingHours;
                TimeSpan bufferTimePerEmployee = TimeSpan.FromHours(1) + TimeSpan.FromMinutes(30);
                TimeSpan totalBufferTime = bufferTimePerEmployee * shop.Employees;

                TimeSpan totalEffectiveWorkTime = (totalWorkingTime * shop.Employees) - totalBufferTime;

                var reservationsGroupedByDate = reservations
                    .GroupBy(r => r.ReservationDate.Date)
                    .ToList();

                var availabilityList = new List<ReservationAvailabilityDTO>();

                foreach (var dayReservations in reservationsGroupedByDate)
                {
                    DateTime currentDate = dayReservations.Key;

                    TimeSpan totalReservedTime = dayReservations
                        .Aggregate(TimeSpan.Zero, (sum, r) => sum + r.TotalDuration);

                    TimeSpan remainingFreeTime = totalEffectiveWorkTime - totalReservedTime;

                    remainingFreeTime = remainingFreeTime < TimeSpan.Zero ? TimeSpan.Zero : remainingFreeTime;

                    availabilityList.Add(new ReservationAvailabilityDTO
                    {
                        Date = currentDate,
                        FreeHours = remainingFreeTime
                    });
                }

                return availabilityList;
            }
            else
            {
                throw new UserException("Shop doesn't exist!");
            }
        }


        public override async Task<ReservationGetDTO> Insert(ReservationInsertDTO request)
        {
            var state = _baseReservationState.CreateState("initial");

            return await state.Insert(request);
        }

        public override async Task<ReservationGetDTO> Update(int id, ReservationUpdateDTO request)
        {
            var entity = await _context.Reservations.FindAsync(id);

            if (entity != null)
            {
                var state = _baseReservationState.CreateState(entity.State);

                return await state.Update(entity, request);
            }
            throw new UserException("Entity doesn't exist!");
        }

        public async Task<ReservationGetDTO> AddFailedPayment(int id, string paymentIntentId)
        {
            var entity = await _context.Reservations.FindAsync(id);

            var state = _baseReservationState.CreateState(entity.State);

            return await state.AddFailedPayment(entity, paymentIntentId);
        }

        public async Task<ReservationGetDTO> AddSuccessfulPayment(int id, string paymentIntentId)
        {
            var entity = await _context.Reservations.FindAsync(id);

            var state = _baseReservationState.CreateState(entity.State);

            return await state.AddSuccessfulPayment(entity, paymentIntentId);
        }

        public async Task<ReservationGetDTO> AddOrder(int id, int orderId, string username)
        {
            var entity = await _context.Reservations.FindAsync(id);

            if (entity != null)
            {
                var state = _baseReservationState.CreateState(entity.State);

                return await state.AddOrder(entity, orderId, username);
            }
            throw new UserException("Entity doesn't exist!");
        }

        public async Task<ReservationGetDTO> Accept(int id, DateTime estimatedCompletionDate)
        {
            var entity = await _context.Reservations.FindAsync(id);

            if (entity != null)
            {
                var state = _baseReservationState.CreateState(entity.State);

                return await state.Accept(entity, estimatedCompletionDate);
            }
            throw new UserException("Entity doesn't exist!");
        }

        public async Task<ReservationGetDTO> UpdateEstimatedDate(int id, DateTime newEstimatedCompletion)
        {
            var entity = await _context.Reservations.FindAsync(id);

            if (entity != null)
            {
                var state = _baseReservationState.CreateState(entity.State);

                return await state.UpdateEstimatedDate(entity, newEstimatedCompletion);
            }
            throw new UserException("Entity doesn't exist!");
        }

        public async Task<ReservationGetDTO> Reject(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);

            if (entity != null)
            {
                var state = _baseReservationState.CreateState(entity.State);

                return await state.Reject(entity);
            }
            throw new UserException("Entity doesn't exist!");
        }

        public async Task<ReservationGetDTO> Cancel(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);

            if (entity != null)
            {
                var state = _baseReservationState.CreateState(entity.State);

                return await state.Cancel(entity);
            }
            throw new UserException("Entity doesn't exist!");
        }

        public async Task<ReservationGetDTO> Resend(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);

            if (entity != null)
            {
                var state = _baseReservationState.CreateState(entity.State);

                return await state.Resend(entity);
            }
            throw new UserException("Entity doesn't exist!");
        }

        public async Task<ReservationGetDTO> Start(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);

            if (entity != null)
            {
                var state = _baseReservationState.CreateState(entity.State);

                return await state.Start(entity);
            }
            throw new UserException("Entity doesn't exist!");
        }

        public async Task<ReservationGetDTO> Complete(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);

            if (entity != null)
            {
                var state = _baseReservationState.CreateState(entity.State);

                return await state.Complete(entity);
            }
            throw new UserException("Entity doesn't exist!");
        }

        public async Task<ReservationGetDTO> SoftDelete(int id, string role)
        {
            var entity = await _context.Reservations.FindAsync(id);

            if (entity != null)
            {
                var state = _baseReservationState.CreateState(entity.State);

                return await state.SoftDelete(entity, role);
            }
            throw new UserException("Entity doesn't exist!");
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);
            var state = _baseReservationState.CreateState(entity?.State ?? "initial");
            return await state.AllowedActions();
        }
    }
}
