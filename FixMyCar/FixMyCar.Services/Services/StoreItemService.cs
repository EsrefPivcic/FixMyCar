using AutoMapper;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.StateMachineServices.StoreItemStateMachine;
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
        public BaseStoreItemState _baseStoreItemState { get; set; }

        public StoreItemService(FixMyCarContext context, IMapper mapper, BaseStoreItemState baseStoreItemState) : base(context, mapper)
        {
            _baseStoreItemState = baseStoreItemState;
        }

        public override IQueryable<StoreItem> AddInclude(IQueryable<StoreItem> query, StoreItemSearchObject? search = null)
        {
            query = query.Include("StoreItemCategory");
            query = query.Include("CarModels");
            return base.AddInclude(query, search);
        }

        public override IQueryable<StoreItem> AddFilter(IQueryable<StoreItem> query, StoreItemSearchObject? search = null)
        {
            if (search != null)
            {
                if (search != null && search?.CarPartsShopName != null)
                {
                    query = query.Where(x => x.CarPartsShop.Username == search.CarPartsShopName);
                }

                if (!string.IsNullOrEmpty(search?.Starts))
                {
                    query = query.Where(x => x.Name.StartsWith(search.Starts));
                }

                if (!string.IsNullOrEmpty(search?.Contains))
                {
                    query = query.Where(x => x.Name.Contains(search.Contains));
                }

                if (!string.IsNullOrEmpty(search?.State))
                {
                    query = query.Where(x => x.State.Contains(search.State));
                }

                if (search?.WithDiscount != null)
                {
                    if (search.WithDiscount == false)
                    {
                        query = query.Where(x => x.Discount == 0);
                    }
                    else
                    {
                        query = query.Where(x => x.Discount != 0);
                    }
                }

                if (!string.IsNullOrEmpty(search?.StoreItemCategoryId.ToString()))
                {
                    query = query.Where(x => x.StoreItemCategoryId == search.StoreItemCategoryId);
                }

                if (search?.CarModelIds != null && search?.CarModelIds?.Count != 0)
                {
                    query = query.Where(x => x.CarModels.Any(cm => search.CarModelIds.Contains(cm.Id)));
                }
            }

            return base.AddFilter(query, search);
        }

        public override async Task<StoreItemGetDTO> Insert (StoreItemInsertDTO request)
        {
            var state = _baseStoreItemState.CreateState("initial");

            return await state.Insert(request);
        }

        public override async Task<StoreItemGetDTO> Update(int id, StoreItemUpdateDTO request)
        {
            var entity = await _context.StoreItems.Include(i => i.StoreItemCarModels).FirstOrDefaultAsync(i => i.Id == id);
            if (entity != null)
            {
                var state = _baseStoreItemState.CreateState(entity.State);
                return await state.Update(entity, request);
            }
            throw new UserException("Entity doesn't exist.");
        }

        public override async Task<string> Delete(int id)
        {
            var set = _context.Set<StoreItem>();

            var entity = await set.FindAsync(id);

            if (entity != null)
            {
                var state = _baseStoreItemState.CreateState(entity.State);

                return await state.Delete(entity);
            }
            return "Entity doesn't exist.";
        }

        public async Task<StoreItemGetDTO> Activate (int id)
        {
            var entity = await _context.StoreItems.Include("CarModels").FirstOrDefaultAsync(si => si.Id == id);

            if (entity != null)
            {
                var state = _baseStoreItemState.CreateState(entity.State);

                return await state.Activate(entity);
            }
            else
            {
                throw new UserException($"Entity ({id}) doesn't exist!");
            }
        }
        
        public async Task<StoreItemGetDTO> Hide (int id)
        {
            var entity = await _context.StoreItems.FindAsync(id);

            var state = _baseStoreItemState.CreateState(entity.State);

            return await state.Hide(entity);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.StoreItems.FindAsync(id);
            var state = _baseStoreItemState.CreateState(entity?.State ?? "initial");
            return await state.AllowedActions();
        }
    }
}