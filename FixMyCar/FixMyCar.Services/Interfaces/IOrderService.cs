﻿using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.DTOs.Product;
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
        Task<OrderGetDTO> Accept(int id);
        Task<OrderGetDTO> Reject(int id);
        Task<OrderGetDTO> Cancel(int id);
        Task<OrderGetDTO> Resend(int id);
        Task<List<string>> AllowedActions(int id);
    }
}
