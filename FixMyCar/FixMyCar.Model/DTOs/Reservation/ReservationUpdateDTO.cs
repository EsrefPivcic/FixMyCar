using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Reservation
{
    public class ReservationUpdateDTO
    {
        public DateTime? ReservationDate { get; set; }
        public DateTime? CompletionDate { get; set; }
        public int? CarRepairShopDiscountId { get; set; }
        public string? PaymentMethod { get; set; }
        public List<int>? Services { get; set; }
    }
}
