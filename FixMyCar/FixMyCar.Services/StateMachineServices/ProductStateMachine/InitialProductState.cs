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
    public class InitialProductState : BaseProductState
    {
        public InitialProductState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<ProductGetDTO> Insert(ProductInsertDTO request)
        {
            var set = _context.Set<Product>();

            var entity = _mapper.Map<Product>(request);

            entity.State = "draft";

            set.Add(entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<ProductGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
