using AutoMapper;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.ProductStateMachine
{
    public class DraftStoreItemState : BaseStoreItemState
    {
        protected ILogger<DraftStoreItemState> _logger;
        public DraftStoreItemState(ILogger<DraftStoreItemState> logger, FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
            _logger = logger;
        }

        public async override Task<StoreItemGetDTO> Update(StoreItem entity, StoreItemUpdateDTO request)
        {
            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<StoreItemGetDTO>(entity);
        }

        public async override Task<StoreItemGetDTO> Activate(StoreItem entity)
        {
            //_logger.LogInformation($"Aktivacija proizvoda: {entity.Id}");
            //_logger.LogWarning($"Aktivacija proizvoda: {entity.Id}");
            //_logger.LogError($"Aktivacija proizvoda: {entity.Id}");

            entity.State = "active";

            await _context.SaveChangesAsync();

            return _mapper.Map<StoreItemGetDTO>(entity);
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
