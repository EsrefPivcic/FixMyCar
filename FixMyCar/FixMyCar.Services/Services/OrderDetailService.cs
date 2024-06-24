using AutoMapper;
using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.DTOs.OrderDetail;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class OrderDetailService : BaseService<OrderDetail, OrderDetailGetDTO, OrderDetailInsertDTO, OrderDetailUpdateDTO, OrderDetailSearchObject>, IOrderDetailService
    {
        public OrderDetailService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
