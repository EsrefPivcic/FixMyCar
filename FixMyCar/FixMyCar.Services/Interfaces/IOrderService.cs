using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IOrderService : IBaseService<Order, OrderGetDTO, OrderInsertDTO, OrderUpdateDTO, OrderSearchObject>
    {
    }
}
