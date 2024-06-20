using AutoMapper;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.StateMachineServices.ProductStateMachine;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class StoreItemService : BaseService<StoreItem, StoreItemGetDTO, StoreItemInsertDTO, StoreItemUpdateDTO, StoreItemSearchObject>, IStoreItemService
    {
        public BaseStoreItemState _baseProductState { get; set; }

        public StoreItemService(FixMyCarContext context, IMapper mapper, BaseStoreItemState baseProductState) : base(context, mapper)
        {
            _baseProductState = baseProductState;
        }

        public override IQueryable<StoreItem> AddFilter(IQueryable<StoreItem> query, StoreItemSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Starts))
            {
                query = query.Where(x => x.Name.StartsWith(search.Starts));
            }

            if (!string.IsNullOrWhiteSpace(search?.Contains))
            {
                query = query.Where(x => x.Name.Contains(search.Contains));
            }

            if (!string.IsNullOrWhiteSpace(search?.State))
            {
                query = query.Where(x => x.State.Contains(search.State));
            }

            return base.AddFilter(query, search);
        }

        public override IQueryable<StoreItem> AddInclude(IQueryable<StoreItem> query, StoreItemSearchObject? search = null)
        {
            if (search?.WithDiscount == false)
            {
                query = query.Where(x => x.DiscountId == null);
                return base.AddInclude(query, search);
            }
            query = query.Include("Discount");
            if (search?.WithDiscount == true)
            {
                query = query.Where(x => x.DiscountId != null);
            }
            return base.AddInclude(query, search);
        }

        public override async Task<StoreItemGetDTO> Insert (StoreItemInsertDTO request)
        {
            var state = _baseProductState.CreateState("initial");

            return await state.Insert(request);
        }

        public override async Task<StoreItemGetDTO> Update (int id, StoreItemUpdateDTO request)
        {
            var entity = await _context.StoreItems.FindAsync(id);

            var state = _baseProductState.CreateState(entity.State);

            return await state.Update(entity, request);
        }

        public async Task<StoreItemGetDTO> Activate (int id)
        {
            var entity = await _context.StoreItems.FindAsync(id);

            var state = _baseProductState.CreateState(entity.State);

            return await state.Activate(entity);
        }
        
        public async Task<StoreItemGetDTO> Hide (int id)
        {
            var entity = await _context.StoreItems.FindAsync(id);

            var state = _baseProductState.CreateState(entity.State);

            return await state.Hide(entity);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.StoreItems.FindAsync(id);
            var state = _baseProductState.CreateState(entity?.State ?? "initial");
            return await state.AllowedActions();
        }
    }
}