using AutoMapper;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.ProductStateMachine
{
    public class ActiveProductState : BaseProductState
    {
        public ActiveProductState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public async override Task<ProductGetDTO> Hide(Product entity)
        {
            entity.State = "draft";

            await _context.SaveChangesAsync();

            return _mapper.Map<ProductGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Hide");

            return list;
        }
    }
}
