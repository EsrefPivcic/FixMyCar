using AutoMapper;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.StateMachineServices.OrderStateMachine
{
    public class InitialOrderState : BaseOrderState
    {
        public InitialOrderState(FixMyCarContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<OrderGetDTO> Insert(OrderInsertDTO request)
        {
            var set = _context.Set<Order>();

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == request.Username) ?? throw new UserException("User not found");

            Order entity = new Order();

            entity.CarPartsShopId = request.CarPartsShopId;
            entity.PaymentMethod = request.PaymentMethod;

            if (request.UserAddress)
            {
                entity.CityId = user.CityId;
                entity.ShippingAddress = user.Address;
                entity.ShippingPostalCode = user.PostalCode;
            }
            else
            {
                entity.ShippingAddress = request.ShippingAddress!;
                entity.ShippingPostalCode = request.ShippingPostalCode!;
                City? city = await _context.Cities.FirstOrDefaultAsync(c => c.Name.ToLower() == request.City!.ToLower());

                if (city != null)
                {
                    entity.CityId = city.Id;
                }
                else
                {
                    var citySet = _context.Set<City>();
                    City newCity = new City
                    {
                        Name = request.City!
                    };
                    await citySet.AddAsync(newCity);
                    await _context.SaveChangesAsync();

                    entity.CityId = newCity.Id;
                }
            }

            if (user is Client)
            {
                entity.ClientId = user.Id;
            }
            else if (user is CarRepairShop)
            {
                entity.CarRepairShopId = user.Id;
            }
            else
            {
                throw new UserException("Invalid user role.");
            }

            entity.State = "onhold";

            entity.TotalAmount = 0;

            foreach (var storeItem in request.StoreItems) 
            {
                var storeItemDetails = await _context.StoreItems.FirstOrDefaultAsync(s => s.Id == storeItem.StoreItemId) ?? throw new UserException("Store item not found");
                entity.TotalAmount = entity.TotalAmount + (storeItemDetails.DiscountedPrice * storeItem.Quantity);
            }

            var discount = await _context.CarPartsShopClientDiscounts.FirstOrDefaultAsync(d => ((d.ClientId == user.Id || d.CarRepairShopId == user.Id) && d.CarPartsShopId == entity.CarPartsShopId) && d.Revoked == null);

            if (discount != null)
            {
                entity.ClientDiscountId = discount.Id;
                entity.TotalAmount = entity.TotalAmount - (entity.TotalAmount * discount.Value);
            }

            entity.OrderDate = DateTime.Now;

            set.Add(entity);

            await _context.SaveChangesAsync();

            await InsertOrderDetails(entity.Id, request.StoreItems);

            return _mapper.Map<OrderGetDTO>(entity);
        }

        private async Task InsertOrderDetails(int orderId, List<StoreItemOrderDTO> storeItems)
        {
            foreach (var storeItem in storeItems) 
            {
                var storeItemDetails = await _context.StoreItems.FirstOrDefaultAsync(s => s.Id == storeItem.StoreItemId) ?? throw new UserException("Store item not found");
                var set = _context.Set<OrderDetail>();
                OrderDetail newOrderDetail = new OrderDetail();
                newOrderDetail.OrderId = orderId;
                newOrderDetail.StoreItemId = storeItemDetails.Id;
                newOrderDetail.Quantity = storeItem.Quantity;
                newOrderDetail.UnitPrice = storeItemDetails.Price;
                newOrderDetail.TotalItemsPrice = storeItemDetails.Price * storeItem.Quantity;
                newOrderDetail.Discount = storeItemDetails.Discount;
                newOrderDetail.TotalItemsPriceDiscounted = (storeItemDetails.Price * storeItem.Quantity) - ((storeItemDetails.Price * storeItem.Quantity) * storeItemDetails.Discount);
                set.Add(newOrderDetail);
                await _context.SaveChangesAsync();
            }
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
