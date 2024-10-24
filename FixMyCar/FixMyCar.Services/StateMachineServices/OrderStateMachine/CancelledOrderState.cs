using AutoMapper;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.OrderStateMachine
{
    public class CancelledOrderState : BaseOrderState
    {
        public CancelledOrderState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<OrderGetDTO> SoftDelete(Order entity, string role)
        {
            if (role == "carpartsshop")
            {
                entity.DeletedByShop = true;
            }
            else if (role == "client" || role == "carrepairshop")
            {
                entity.DeletedByCustomer = true;
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<OrderGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("SoftDelete");

            return list;
        }
    }
}
