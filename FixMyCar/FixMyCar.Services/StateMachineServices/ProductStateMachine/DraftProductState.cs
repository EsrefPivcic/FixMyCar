using AutoMapper;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
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
        public DraftProductState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public async override Task<ProductGetDTO> Update(Product entity, ProductUpdateDTO request)
        {
            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<ProductGetDTO>(entity);
        }

        public async override Task<ProductGetDTO> Activate(Product entity)
        {
            entity.State = "active";

            await _context.SaveChangesAsync();

            return _mapper.Map<ProductGetDTO>(entity);
        }
    }
}
