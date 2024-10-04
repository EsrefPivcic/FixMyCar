using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShopService;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.StateMachineServices.CarRepairShopServiceStateMachine;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class CarRepairShopServiceService : BaseService<Model.Entities.CarRepairShopService, CarRepairShopServiceGetDTO, CarRepairShopServiceInsertDTO, CarRepairShopServiceUpdateDTO, CarRepairShopServiceSearchObject>, ICarRepairShopServiceService
    {
        public BaseCarRepairShopServiceState _baseCarRepairShopServiceState;
        public CarRepairShopServiceService(FixMyCarContext context, IMapper mapper, BaseCarRepairShopServiceState baseCarRepairShopServiceState) : base(context, mapper)
        {
            _baseCarRepairShopServiceState = baseCarRepairShopServiceState;
        }

        public override IQueryable<Model.Entities.CarRepairShopService> AddInclude(IQueryable<Model.Entities.CarRepairShopService> query, CarRepairShopServiceSearchObject? search = null)
        {
            query = query.Include("CarRepairShop");
            query = query.Include("ServiceType");
            return base.AddInclude(query, search);
        }

        public override IQueryable<Model.Entities.CarRepairShopService> AddFilter(IQueryable<Model.Entities.CarRepairShopService> query, CarRepairShopServiceSearchObject? search = null)
        {
            if (search != null)
            {
                if (search != null && search?.CarRepairShopName != null)
                {
                    query = query.Where(x => x.CarRepairShop.Username == search.CarRepairShopName);
                }
                if (!string.IsNullOrEmpty(search?.Name))
                {
                    query = query.Where(x => x.Name.Contains(search.Name));
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
                if (search?.ServiceType != null) 
                {
                    query = query.Where(x => x.ServiceType.Name == search.ServiceType);
                }
            }
            return base.AddFilter(query, search);
        }
        public override async Task<CarRepairShopServiceGetDTO> Insert(CarRepairShopServiceInsertDTO request)
        {
            if (request.ServiceTypeId != null && request.Name != null && request.Price != null && request.Duration != null)
            {
               var state = _baseCarRepairShopServiceState.CreateState("initial");
               return await state.Insert(request);
            }
            throw new UserException("Please insert all properties.");
        }

        public override async Task<CarRepairShopServiceGetDTO> Update(int id, CarRepairShopServiceUpdateDTO request)
        {
            var entity = await _context.CarRepairShopServices.FindAsync(id);
            if (entity != null)
            {
                var state = _baseCarRepairShopServiceState.CreateState(entity.State);
                return await state.Update(entity, request);
            }
            throw new UserException("Entity doesn't exist.");
        }

        public override async Task<string> Delete(int id)
        {
            var set = _context.Set<Model.Entities.CarRepairShopService>();

            var entity = await set.FindAsync(id);

            if (entity != null)
            {
                var state = _baseCarRepairShopServiceState.CreateState(entity.State);

                return await state.Delete(entity);
            }
            return "Entity doesn't exist.";
        }

        public async Task<CarRepairShopServiceGetDTO> Activate(int id)
        {
            var entity = await _context.CarRepairShopServices.Include("CarRepairShop").FirstOrDefaultAsync(s => s.Id == id);

            var state = _baseCarRepairShopServiceState.CreateState(entity.State);

            return await state.Activate(entity);
        }

        public async Task<CarRepairShopServiceGetDTO> Hide(int id)
        {
            var entity = await _context.CarRepairShopServices.FindAsync(id);

            var state = _baseCarRepairShopServiceState.CreateState(entity.State);

            return await state.Hide(entity);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.CarRepairShopServices.FindAsync(id);
            var state = _baseCarRepairShopServiceState.CreateState(entity?.State ?? "initial");
            return await state.AllowedActions();
        }
    }
}
