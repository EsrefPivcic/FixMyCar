using AutoMapper;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.OrderStateMachine
{
    public class CancelledOrderState : BaseOrderState
    {
        public CancelledOrderState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public async override Task<OrderGetDTO> Update(Order entity, OrderUpdateDTO request)
        {
            _mapper.Map(request, entity);

            if (request.ShippingCity != null)
            {
                City? city = await _context.Cities.FirstOrDefaultAsync(c => c.Name.ToLower() == request.ShippingCity!.ToLower());

                if (city != null)
                {
                    entity.CityId = city.Id;
                }
                else
                {
                    var citySet = _context.Set<City>();
                    City newCity = new City
                    {
                        Name = request.ShippingCity!
                    };
                    await citySet.AddAsync(newCity);
                    await _context.SaveChangesAsync();

                    entity.CityId = newCity.Id;
                }
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<OrderGetDTO>(entity);
        }

        public async override Task<OrderGetDTO> Resend(Order entity)
        {
            entity.State = "onhold";

            await _context.SaveChangesAsync();

            return _mapper.Map<OrderGetDTO>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Update");
            list.Add("Resend");

            return list;
        }
    }
}
