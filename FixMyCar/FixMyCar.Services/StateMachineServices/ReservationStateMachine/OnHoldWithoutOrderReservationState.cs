using AutoMapper;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.ReservationStateMachine
{
    public class OnHoldWithoutOrderReservationState : BaseReservationState
    {
        public OnHoldWithoutOrderReservationState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<ReservationGetDTO> AddOrder(Reservation entity, ReservationUpdateDTO request)
        {
            entity.OrderId = request.OrderId;

            entity.State = "onholdwithorder";

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<ReservationGetDTO> Update(Reservation entity, ReservationUpdateDTO request)
        {
            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<ReservationGetDTO> Reject(Reservation entity)
        {
            entity.State = "rejected";

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<ReservationGetDTO> Cancel(Reservation entity)
        {
            entity.State = "cancelled";

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("AddOrder");
            list.Add("Update");
            list.Add("Reject");
            list.Add("Cancel");

            return list;
        }
    }
}
