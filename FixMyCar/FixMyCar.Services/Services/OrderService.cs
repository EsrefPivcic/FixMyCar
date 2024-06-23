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

namespace FixMyCar.Services.Services
{
    public class OrderService : BaseService<Order, OrderGetDTO, OrderInsertDTO, OrderUpdateDTO, OrderSearchObject>, IOrderService
    {
        public OrderService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        { 
        }
    }
}
