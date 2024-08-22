using AutoMapper;
using FixMyCar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.ReservationStateMachine
{
    public class RejectedReservationState : BaseReservationState
    {
        public RejectedReservationState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Rejected reservations can't be updated or have its state changed.");

            return list;
        }
    }
}
