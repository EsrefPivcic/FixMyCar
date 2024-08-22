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
    public class CancelledReservationState : BaseReservationState
    {
        public CancelledReservationState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<ReservationGetDTO> Update(Reservation entity, ReservationUpdateDTO request)
        {
            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<ReservationGetDTO> Resend(Reservation entity)
        {
            if (entity.OrderId != null)
            {
                entity.State = "onholdwithorder";
            }
            else
            {
                entity.State = "onholdwithoutorder";
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Resend");
            list.Add("Update");

            return list;
        }
    }
}
