﻿using AutoMapper;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.StoreItemStateMachine
{
    public class DraftStoreItemState : BaseStoreItemState
    {
        public DraftStoreItemState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public async override Task<StoreItemGetDTO> Update(StoreItem entity, StoreItemUpdateDTO request)
        {
            _mapper.Map(request, entity);

            if (request.CarModelIds != null)
            {
                var existingCarModelAssociations = await _context.StoreItemCarModels
                    .Where(sicm => sicm.StoreItemId == entity.Id)
                    .ToListAsync();

                _context.StoreItemCarModels.RemoveRange(existingCarModelAssociations);

                foreach (var carModelId in request.CarModelIds)
                {
                    await _context.StoreItemCarModels.AddAsync(new StoreItemCarModel
                    {
                        StoreItemId = entity.Id,
                        CarModelId = carModelId
                    });
                }
            }

            entity.DiscountedPrice = entity.Price - (entity.Price * entity.Discount);

            await _context.SaveChangesAsync();

            return _mapper.Map<StoreItemGetDTO>(entity);
        }

        public async override Task<StoreItemGetDTO> Activate(StoreItem entity)
        {
            bool validate = !string.IsNullOrWhiteSpace(entity.Details) && !entity.CarModels.IsNullOrEmpty() && entity.StoreItemCategoryId != null;
            if (validate)
            {
                entity.State = "active";

                await _context.SaveChangesAsync();

                return _mapper.Map<StoreItemGetDTO>(entity);
            }
            else
            {
                throw new UserException("Please insert all item details before activating the item!");
            }
        }

        public async override Task<string> Delete(StoreItem entity)
        {
            var set = _context.Set<StoreItem>();

            set.Remove(entity);

            await _context.SaveChangesAsync();

            return $"Successfully deleted: {Environment.NewLine} {entity.Name}";
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Update");
            list.Add("Activate");
            list.Add("Delete");

            return list;
        }
    }
}
