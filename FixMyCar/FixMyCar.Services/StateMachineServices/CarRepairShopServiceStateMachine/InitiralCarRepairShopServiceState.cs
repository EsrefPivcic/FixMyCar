using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShopService;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Utilities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.CarRepairShopServiceStateMachine
{
    public class InitiralCarRepairShopServiceState : BaseCarRepairShopServiceState
    {
        public InitiralCarRepairShopServiceState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<CarRepairShopServiceGetDTO> Insert(CarRepairShopServiceInsertDTO request)
        {
            var set = _context.Set<CarRepairShopService>();

            var entity = _mapper.Map<CarRepairShopService>(request);

            var user = await _context.Users.FirstAsync(u => u.Username == request.CarRepairShopName) ?? throw new UserException("User not found");

            entity.CarRepairShopId = user.Id;

            entity.State = "draft";

            entity.DiscountedPrice = entity.Price - (entity.Price * entity.Discount);

            if (request.ImageData == null || request.ImageData == "")
            {
                ServiceType? serviceType = await _context.ServiceTypes.FindAsync(request.ServiceTypeId);

                if (serviceType?.Name == "Repairs")
                {
                    entity.ImageData = serviceType.Image;
                }
                else if (serviceType?.Name == "Diagnostics")
                {
                    entity.ImageData = serviceType.Image;
                }
                else
                {
                    entity.ImageData = null;
                }
            }
            else
            {
                byte[] newImage = Convert.FromBase64String(request.ImageData);
                entity.ImageData = newImage;
            }

            set.Add(entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<CarRepairShopServiceGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
