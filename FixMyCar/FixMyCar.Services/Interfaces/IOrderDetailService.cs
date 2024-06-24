using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.DTOs.OrderDetail;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IOrderDetailService : IBaseService<OrderDetail, OrderDetailGetDTO, OrderDetailInsertDTO, OrderDetailUpdateDTO, OrderDetailSearchObject>
    {
    }
}
