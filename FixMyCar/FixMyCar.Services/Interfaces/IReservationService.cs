using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IReservationService : IBaseService<Reservation, ReservationGetDTO, ReservationInsertDTO, ReservationUpdateDTO, ReservationSearchObject>
    {
        Task<ReservationGetDTO> AddOrder(int id, int orderId, string username);
        Task<ReservationGetDTO> Accept(int id, DateTime estimatedCompletionDate);
        Task<ReservationGetDTO> Reject(int id);
        Task<ReservationGetDTO> Cancel(int id);
        Task<ReservationGetDTO> Resend(int id);
        Task<ReservationGetDTO> Start(int id);
        Task<ReservationGetDTO> UpdateEstimatedDate(int id, DateTime newEstimatedCompletion);
        Task<ReservationGetDTO> Complete(int id);
        Task<List<string>> AllowedActions(int id);
        Task<ReservationGetDTO> AddSuccessfulPayment(int id, string paymentIntentId);
        Task<ReservationGetDTO> AddFailedPayment(int id, string paymentIntentId);
    }
}
