using AutoMapper;
using FixMyCar.Model.DTOs.OrderDetail;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
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

        public override IQueryable<OrderDetail> AddInclude(IQueryable<OrderDetail> query, OrderDetailSearchObject? search = null)
        {
            query = query.Include("StoreItem");

            return base.AddInclude(query, search);
        }

        public override IQueryable<OrderDetail> AddFilter(IQueryable<OrderDetail> query, OrderDetailSearchObject? search = null)
        {
            if (search != null)
            {
                if (search?.OrderId != null)
                {
                    query = query.Where(od => od.OrderId == search.OrderId);
                }
            }
            return base.AddFilter(query, search);
        }
    }
}
