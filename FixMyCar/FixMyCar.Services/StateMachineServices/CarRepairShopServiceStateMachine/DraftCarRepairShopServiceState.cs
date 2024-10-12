using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShopService;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Services;
using FixMyCar.Services.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.CarRepairShopServiceStateMachine
{
    public class DraftCarRepairShopServiceState : BaseCarRepairShopServiceState
    {
        public DraftCarRepairShopServiceState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public async override Task<CarRepairShopServiceGetDTO> Update(Model.Entities.CarRepairShopService entity, CarRepairShopServiceUpdateDTO request)
        {
            _mapper.Map(request, entity);

            entity.DiscountedPrice = entity.Price - (entity.Price * entity.Discount);

            if (request.ImageData != null)
            {
                byte[] newImage = Convert.FromBase64String(request.ImageData);
                entity.ImageData = ImageHelper.Resize(newImage, 150);
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<CarRepairShopServiceGetDTO>(entity);
        }

        public async override Task<CarRepairShopServiceGetDTO> Activate(Model.Entities.CarRepairShopService entity)
        {
            entity.State = "active";

            await _context.SaveChangesAsync();

            return _mapper.Map<CarRepairShopServiceGetDTO>(entity);
        }

        public async override Task<string> Delete(Model.Entities.CarRepairShopService entity)
        {
            var set = _context.Set<Model.Entities.CarRepairShopService>();

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
