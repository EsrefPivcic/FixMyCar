using AutoMapper;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.ProductStateMachine
{
    public class InitialStoreItemState : BaseStoreItemState
    {
        public InitialStoreItemState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<StoreItemGetDTO> Insert(StoreItemInsertDTO request)
        {
            var set = _context.Set<StoreItem>();

            var entity = _mapper.Map<StoreItem>(request);

            entity.State = "draft";

            entity.DiscountedPrice = entity.Price - (entity.Price * entity.Discount);

            if (request.CarModelIds != null)
            {
                foreach (var carModelId in request.CarModelIds)
                {
                    await _context.StoreItemCarModels.AddAsync(new StoreItemCarModel
                    {
                        StoreItemId = entity.Id,
                        CarModelId = carModelId
                    });
                }
            }

            set.Add(entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<StoreItemGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
