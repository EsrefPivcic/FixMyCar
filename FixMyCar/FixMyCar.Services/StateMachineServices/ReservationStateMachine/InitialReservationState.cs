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

            Reservation entity = _mapper.Map<Reservation>(request);

            entity.ClientId = user.Id;

            if (request.OrderId == null) 
            {
                entity.State = "onholdwithoutorder";
            }
            else
            {
                entity.State = "onholdwithorder";
            }

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
