using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using FixMyCar.Services.StateMachineServices.OrderStateMachine;
using Microsoft.EntityFrameworkCore;

namespace FixMyCar.Services.Services
{
    public class OrderService : BaseService<Order, OrderGetDTO, OrderInsertDTO, OrderUpdateDTO, OrderSearchObject>, IOrderService
    {
        public BaseOrderState _baseOrderState { get; set; }
        public OrderService(FixMyCarContext context, IMapper mapper, BaseOrderState baseOrderState) : base(context, mapper)
        { 
            _baseOrderState = baseOrderState;
        }

        public override IQueryable<Order> AddInclude(IQueryable<Order> query, OrderSearchObject? search = null)
        {
            query = query.Include("CarRepairShop");
            query = query.Include("CarPartsShop");
            query = query.Include("Client");
            query = query.Include("City");
            query = query.Include("ClientDiscount");
            return base.AddInclude(query, search);
        }

        public override IQueryable<Order> AddFilter(IQueryable<Order> query, OrderSearchObject? search = null)
        {
            if (search != null)
            {
                if (search?.CarPartsShopName != null)
                {
                    query = query.Where(o => o.CarPartsShop.Username == search.CarPartsShopName);
                }

                if (!string.IsNullOrEmpty(search?.Role))
                {
                    if (search?.Role == "Client")
                    {
                        query = query.Where(x => x.ClientId != null);
                    }
                    else
                    {
                        query = query.Where(x => x.CarRepairShopId != null);
                    }
                }

                if (search?.Discount != null)
                {
                    if (search.Discount == true)
                    {
                        query = query.Where(x => x.ClientDiscountId != null);
                    }
                    else
                    {
                        query = query.Where(x => x.ClientDiscountId == null);
                    }
                }

                if (!string.IsNullOrEmpty(search?.State))
                {
                    query = query.Where(x => x.State.Contains(search.State));

                    if (search?.State == "accepted" && (search.MinShippingDate != null || search?.MaxShippingDate != null))
                    {
                        if (search?.MinShippingDate != null && search?.MaxShippingDate != null)
                        {
                            query = query.Where(x => x.ShippingDate >= search.MinShippingDate && x.OrderDate <= search.MaxShippingDate);
                        }

                        if (search?.MinShippingDate != null && search?.MaxShippingDate == null)
                        {
                            query = query.Where(x => x.ShippingDate >= search.MinShippingDate);
                        }

                        if (search?.MinShippingDate == null && search?.MaxShippingDate != null)
                        {
                            query = query.Where(x => x.ShippingDate <= search.MaxShippingDate);
                        }
                    }
                }

                if (search?.MinTotalAmount != null && search?.MaxTotalAmount != null)
                {
                    query = query.Where(x => x.TotalAmount >= search.MinTotalAmount && x.TotalAmount <= search.MaxTotalAmount);
                }

                if (search?.MinTotalAmount != null && search?.MaxTotalAmount == null)
                {
                    query = query.Where(x => x.TotalAmount >= search.MinTotalAmount);
                }

                if (search?.MinTotalAmount == null && search?.MaxTotalAmount != null)
                {
                    query = query.Where(x => x.TotalAmount <= search.MaxTotalAmount);
                }

                if (search?.MinOrderDate != null && search?.MaxOrderDate != null)
                {
                    query = query.Where(x => x.OrderDate >= search.MinOrderDate && x.OrderDate <= search.MaxOrderDate);
                }

                if (search?.MinOrderDate != null && search?.MaxOrderDate == null)
                {
                    query = query.Where(x => x.OrderDate >= search.MinOrderDate);
                }

                if (search?.MinOrderDate == null && search?.MaxOrderDate != null)
                {
                    query = query.Where(x => x.OrderDate <= search.MaxOrderDate);
                }
            }
            return base.AddFilter(query, search);
        }

        public override async Task<OrderGetDTO> Insert(OrderInsertDTO request)
        {
            var state = _baseOrderState.CreateState("initial");

            return await state.Insert(request);
        }

        public override async Task<OrderGetDTO> Update(int id, OrderUpdateDTO request)
        {
            var entity = await _context.Orders.FindAsync(id);

            var state = _baseOrderState.CreateState(entity.State);

            return await state.Update(entity, request);
        }

        public async Task<OrderGetDTO> Accept(int id, OrderAcceptDTO orderAccept)
        {
            var entity = await _context.Orders.FindAsync(id);

            var state = _baseOrderState.CreateState(entity.State);

            return await state.Accept(entity, orderAccept);
        }

        public async Task<OrderGetDTO> Reject(int id)
        {
            var entity = await _context.Orders.FindAsync(id);

            var state = _baseOrderState.CreateState(entity.State);

            return await state.Reject(entity);
        }

        public async Task<OrderGetDTO> Cancel(int id)
        {
            var entity = await _context.Orders.FindAsync(id);

            var state = _baseOrderState.CreateState(entity.State);

            return await state.Cancel(entity);
        }

        public async Task<OrderGetDTO> Resend(int id)
        {
            var entity = await _context.Orders.FindAsync(id);

            var state = _baseOrderState.CreateState(entity.State);

            return await state.Resend(entity);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Orders.FindAsync(id);
            var state = _baseOrderState.CreateState(entity?.State ?? "initial");
            return await state.AllowedActions();
        }
    }
}
