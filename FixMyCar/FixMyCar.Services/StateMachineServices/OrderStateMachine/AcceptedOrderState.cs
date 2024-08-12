using AutoMapper;
using FixMyCar.Services.Database;
using FixMyCar.Services.StateMachineServices.StoreItemStateMachine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.OrderStateMachine
{
    public class AcceptedOrderState : BaseOrderState
    {
        public AcceptedOrderState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Accepted orders can't be updated or have its state changed.");

            return list;
        }
    }
}
