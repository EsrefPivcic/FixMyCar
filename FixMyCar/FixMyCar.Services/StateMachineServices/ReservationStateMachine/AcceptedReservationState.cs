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
    public class AcceptedReservationState : BaseReservationState
    {
        public AcceptedReservationState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<ReservationGetDTO> Complete(Reservation entity)
        {
            entity.State = "completed";

            entity.CompletionDate = DateTime.Now;

            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Complete");

            return list;
        }
    }
}
