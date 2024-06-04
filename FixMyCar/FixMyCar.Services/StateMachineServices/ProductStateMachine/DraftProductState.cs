﻿using AutoMapper;
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
    public class DraftProductState : BaseProductState
    {
        protected ILogger<DraftProductState> _logger;
        public DraftProductState(ILogger<DraftProductState> logger, FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
            _logger = logger;
        }

        public async override Task<ProductGetDTO> Update(Product entity, ProductUpdateDTO request)
        {
            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<ProductGetDTO>(entity);
        }

        public async override Task<ProductGetDTO> Activate(Product entity)
        {
            _logger.LogInformation($"Aktivacija proizvoda: {entity.Id}");
            _logger.LogWarning($"Aktivacija proizvoda: {entity.Id}");
            _logger.LogError($"Aktivacija proizvoda: {entity.Id}");

            entity.State = "active";

            await _context.SaveChangesAsync();

            return _mapper.Map<ProductGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Update");
            list.Add("Activate");

            return list;
        }
    }
}