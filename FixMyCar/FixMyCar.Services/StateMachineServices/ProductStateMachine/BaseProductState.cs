using AutoMapper;
using FixMyCar.Model.Utilities;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.ProductStateMachine
{
    public class BaseProductState
    {
        protected FixMyCarContext _context;
        protected IMapper _mapper;
        public IServiceProvider _serviceProvider;

        public BaseProductState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual async Task<ProductGetDTO> Insert(ProductInsertDTO request)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ProductGetDTO> Update(Product entity, ProductUpdateDTO request)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ProductGetDTO> Activate(Product entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ProductGetDTO> Hide(Product entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<ProductGetDTO> Delete(Product entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }

        public BaseProductState CreateState(string state)
        {
            switch(state)
            {
                case "initial":
                    case null:
                    return _serviceProvider.GetService<InitialProductState>();
                    break;
                case "draft":
                    return _serviceProvider.GetService<DraftProductState>();
                    break;
                case "active":
                    return _serviceProvider.GetService<ActiveProductState>();
                    break;

                default:
                    throw new UserException("Action not allowed.");
            }
        }
    }
}
