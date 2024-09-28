using AutoMapper;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.OrderStateMachine
{
    public class PaymentFailedOrderState : BaseOrderState
    {
        public PaymentFailedOrderState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Orders with failed payment can't be updated or have it's state changed.");

            return list;
        }
    }
}
