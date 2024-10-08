﻿using AutoMapper;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FixMyCar.Model.Utilities;

namespace FixMyCar.Services.StateMachineServices.StoreItemStateMachine
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

            var user = await _context.Users.FirstAsync(u => u.Username == request.Username) ?? throw new UserException("User not found");

            entity.CarPartsShopId = user.Id;

            entity.State = "draft";

            entity.DiscountedPrice = entity.Price - (entity.Price * entity.Discount);

            set.Add(entity);

            await _context.SaveChangesAsync();

            if (request.CarModelIds != null)
            {
                await AddStoreItemCarModels(request.CarModelIds, entity.Id);
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<StoreItemGetDTO>(entity);
        }

        internal async Task AddStoreItemCarModels(List<int> carModelIds, int storeItemId)
        {
            foreach (var carModelId in carModelIds)
            {
                await _context.StoreItemCarModels.AddAsync(new StoreItemCarModel
                {
                    StoreItemId = storeItemId,
                    CarModelId = carModelId
                });
            }
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
