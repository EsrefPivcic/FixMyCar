using AutoMapper;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
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
            var set = _context.Set<Reservation>();

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == request.ClientUsername) ?? throw new UserException("User not found");

            if (request.OrderId != null)
            {
                var order = await _context.Orders.Include("Client").FirstOrDefaultAsync(x => x.Id == request.OrderId) ?? throw new UserException($"Order #{request.OrderId} doesn't exist!");

                if (order.Client == null || order.Client!.Username != user.Username)
                {
                    throw new UserException($"Order #{request.OrderId} is not made by {user.Username}!");
                }
            }

            bool repairs = false;
            bool diagnostics = false;

            foreach (var serviceId in request.Services)
            {
                var service = await _context.CarRepairShopServices.Include("ServiceType").FirstOrDefaultAsync(s => s.Id == serviceId) ?? throw new UserException($"Repair shop service #{serviceId} not found");
                if (service.ServiceType.Name == "Repairs")
                {
                    repairs = true;
                }
                if (service.ServiceType.Name == "Diagnostics")
                {
                    diagnostics = true;
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
                        entity.State = "onholdwithoutorder";
                    }
                }
                else
                {
                    entity.State = "onholdwithorder";
                    entity.ClientOrder = true;
                }
            }
            else
            {
                entity.Type = "Diagnostics";
                entity.State = "onholdwithorder";
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
