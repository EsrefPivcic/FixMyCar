using AutoMapper;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.ReservationStateMachine
{
    public class OnHoldWithOrderReservationState : BaseReservationState
    {
        public OnHoldWithOrderReservationState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<ReservationGetDTO> Update(Reservation entity, ReservationUpdateDTO request)
        {
            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<ReservationGetDTO> Accept(Reservation entity)
        {
            entity.State = "accepted";

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

            list.Add("Accept");
            list.Add("Update");
            list.Add("Reject");
            list.Add("Cancel");

            return list;
        }
    }
}
