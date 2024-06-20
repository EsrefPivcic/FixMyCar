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
    public class BaseStoreItemState
    {
        protected FixMyCarContext _context;
        protected IMapper _mapper;
        public IServiceProvider _serviceProvider;

        public BaseStoreItemState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual async Task<StoreItemGetDTO> Insert(StoreItemInsertDTO request)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<StoreItemGetDTO> Update(StoreItem entity, StoreItemUpdateDTO request)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<StoreItemGetDTO> Activate(StoreItem entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<StoreItemGetDTO> Hide(StoreItem entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<StoreItemGetDTO> Delete(StoreItem entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }

        public BaseStoreItemState CreateState(string state)
        {
            switch(state)
            {
                case "initial":
                    case null:
                    return _serviceProvider.GetService<InitialStoreItemState>();
                    break;
                case "draft":
                    return _serviceProvider.GetService<DraftStoreItemState>();
                    break;
                case "active":
                    return _serviceProvider.GetService<ActiveStoreItemState>();
                    break;

                default:
                    throw new UserException("Action not allowed.");
            }
        }
    }
}
