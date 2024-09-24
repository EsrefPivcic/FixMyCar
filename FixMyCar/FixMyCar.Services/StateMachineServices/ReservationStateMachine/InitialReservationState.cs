using AutoMapper;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Utilities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.ReservationStateMachine
{
    public class InitialReservationState : BaseReservationState
    {
        public InitialReservationState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<ReservationGetDTO> Insert(ReservationInsertDTO request)
        {
            var repairShop = await _context.Users.OfType<CarRepairShop>().FirstOrDefaultAsync(c => c.Id == request.CarRepairShopId);

            if (repairShop == null)
            {
                throw new UserException("Car repair shop not valid!"); 
            }

            bool isOnWorkDay = Validation.IsReservationOnWorkday(request.ReservationDate, repairShop);

            if (!isOnWorkDay)
            {
                throw new UserException($"Can't make a reservation on a non-work day! ({request.ReservationDate.DayOfWeek})");
            }

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == request.ClientUsername) ?? throw new UserException("User not found");

            if (request.OrderId != null)
            {
                var order = await _context.Orders.Include("Client").FirstOrDefaultAsync(x => x.Id == request.OrderId) ?? throw new UserException($"Order #{request.OrderId} doesn't exist!");

                if (order.Client == null || order.Client!.Username != user.Username)
                {
                    throw new UserException($"Order #{request.OrderId} is not made by {user.Username}!");
                }

                var alreadyUsed = await _context.Reservations.FirstOrDefaultAsync(x => x.OrderId == order.Id);

                if (alreadyUsed != null)
                {
                    throw new UserException($"This order is already used for reservation #{alreadyUsed.Id}.");
                }
            }

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
                else
                {
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
            }

            List<Reservation>? reservations = _context.Reservations.Where(r => r.ReservationDate.Date == request.ReservationDate.Date && r.CarRepairShopId == request.CarRepairShopId).ToList();

            if (reservations != null)
            {
                bool isWithinWorkHours = Validation.IsWithinWorkHours(totalDuration, repairShop.WorkingHours, reservations);

                if (!isWithinWorkHours) 
                {
                    throw new UserException($"You can't make a reservation on {request.ReservationDate.Day}.{request.ReservationDate.Month}.{request.ReservationDate.Year}. since there is too many reservations on that day.");
                }
            }

            Reservation entity = _mapper.Map<Reservation>(request);

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

                if (request.OrderId == null)
                {
                    if (request.ClientOrder == null)
                    {
                        throw new UserException("Please specify who is responsible for ordering car parts!");
                    }
                    else
                    {
                        entity.State = "awaitingorder";
                    }
                }
                else
                {
                    var order = await _context.Orders.FindAsync(request.OrderId);
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
                    entity.ClientOrder = true;
                }
            }
            else
            {
                entity.Type = "Diagnostics";
                entity.State = "ready";
                entity.ClientOrder = null;
                entity.OrderId = null;
            }

            entity.ClientId = user.Id;

            entity.TotalAmount = 0;
            entity.TotalDuration = new TimeSpan();

            foreach (var serviceId in request.Services)
            {
                var service = await _context.CarRepairShopServices.FirstOrDefaultAsync(s => s.Id == serviceId);
                if (service != null)
                {
                    entity.TotalAmount += service.DiscountedPrice;
                    entity.TotalDuration += service.Duration;
                }
            }

            var discount = await _context.CarRepairShopDiscounts.FirstOrDefaultAsync(d => (d.ClientId == user.Id && d.CarRepairShopId == request.CarRepairShopId) && d.Revoked == null);

            if (discount != null)
            {
                entity.CarRepairShopDiscountId = discount.Id;
                entity.TotalAmount = entity.TotalAmount - (entity.TotalAmount * discount.Value);
            }

            entity.ReservationCreatedDate = DateTime.Now;

            var set = _context.Set<Reservation>();

            set.Add(entity);

            await _context.SaveChangesAsync();

            await InsertReservationDetails(entity.Id, request.Services);

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public async Task InsertReservationDetails(int reservationId, List<int> services)
        {
            foreach (var serviceId in services) 
            {
                var service = await _context.CarRepairShopServices.FirstOrDefaultAsync(s => s.Id == serviceId) ?? throw new UserException("Repair shop service not found");
                var set = _context.Set<ReservationDetail>();
                ReservationDetail newReservationDetail = new ReservationDetail();
                newReservationDetail.ReservationId = reservationId;
                newReservationDetail.CarRepairShopServiceId = service.Id;
                newReservationDetail.ServiceName = service.Name;
                newReservationDetail.ServicePrice = service.Price;
                newReservationDetail.ServiceDiscount = service.Discount;
                newReservationDetail.ServiceDiscountedPrice = service.DiscountedPrice;
                set.Add(newReservationDetail);
                await _context.SaveChangesAsync();
            }
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
