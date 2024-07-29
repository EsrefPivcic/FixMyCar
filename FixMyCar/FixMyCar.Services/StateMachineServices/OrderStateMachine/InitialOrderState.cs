using AutoMapper;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.OrderStateMachine
{
    public class InitialOrderState : BaseOrderState
    {
        public InitialOrderState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<OrderGetDTO> Insert(OrderInsertDTO request)
        {
            var set = _context.Set<Order>();

            var entity = _mapper.Map<Order>(request);

            entity.State = "onhold";

            set.Add(entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<OrderGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
