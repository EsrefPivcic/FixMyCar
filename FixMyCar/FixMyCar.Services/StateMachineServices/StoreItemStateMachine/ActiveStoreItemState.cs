using AutoMapper;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.ProductStateMachine
{
    public class ActiveStoreItemState : BaseStoreItemState
    {
        public ActiveStoreItemState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public async override Task<StoreItemGetDTO> Hide(StoreItem entity)
        {
            entity.State = "draft";

            await _context.SaveChangesAsync();

            return _mapper.Map<StoreItemGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Hide");

            return list;
        }
    }
}
