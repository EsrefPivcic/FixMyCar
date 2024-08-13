using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShopService;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.CarRepairShopServiceStateMachine
{
    public class BaseCarRepairShopServiceState
    {
        protected FixMyCarContext _context;
        protected IMapper _mapper;
        public IServiceProvider _serviceProvider;

        public BaseCarRepairShopServiceState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual async Task<CarRepairShopServiceGetDTO> Insert(CarRepairShopServiceInsertDTO request)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<CarRepairShopServiceGetDTO> Update(CarRepairShopService entity, CarRepairShopServiceUpdateDTO request)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<CarRepairShopServiceGetDTO> Activate(CarRepairShopService entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<CarRepairShopServiceGetDTO> Hide(CarRepairShopService entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<string> Delete(CarRepairShopService entity)
        {
            throw new UserException("Action not allowed.");
        }

        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }

        public BaseCarRepairShopServiceState CreateState(string state)
        {
            switch (state)
            {
                case "initial":
                case null:
                    return _serviceProvider.GetService<InitiralCarRepairShopServiceState>()!;
                case "draft":
                    return _serviceProvider.GetService<DraftCarRepairShopServiceState>()!;
                case "active":
                    return _serviceProvider.GetService<ActiveCarRepairShopServiceState>()!;

                default:
                    throw new UserException("Action not allowed.");
            }
        }
    }
}
