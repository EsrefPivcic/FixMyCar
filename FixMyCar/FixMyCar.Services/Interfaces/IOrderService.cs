using FixMyCar.Model.DTOs.Order;
using FixMyCar.Model.DTOs.StoreItem;
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
        Task<OrderGetDTO> Accept(int id, OrderAcceptDTO orderAccept);
        Task<OrderGetDTO> Reject(int id);
        Task<OrderGetDTO> Cancel(int id);
        Task<OrderGetDTO> Resend(int id);

        Task<OrderGetDTO> AddFailedPayment(int id, string paymentIntentId);
        Task<OrderGetDTO> AddSuccessfulPayment(int id, string paymentIntentId);
        Task<List<string>> AllowedActions(int id);
        Task<OrderBasicInfoGetDTO> GetBasicOrderInfo(int id);
        Task<OrderGetDTO> SoftDelete(int id, string role);
    }
}
