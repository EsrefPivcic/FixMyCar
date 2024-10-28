using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Reservation
{
    public class ReservationGetDTO
    {
        public int Id { get; set; }
        public string CarRepairShopName { get; set; }
        public string ClientUsername { get; set; }
        public int? OrderId { get; set; }
        public bool? ClientOrder { get; set; }
        public string CarModel { get; set; }
        public DateTime ReservationCreatedDate { get; set; }
        public DateTime ReservationDate { get; set; }
        public DateTime? EstimatedCompletionDate { get; set; }
        public DateTime? CompletionDate { get; set; }
        public double TotalAmount { get; set; }
        public TimeSpan TotalDuration { get; set; }
        public double CarRepairShopDiscountValue { get; set; }
        public string State { get; set; }
        public string Type { get; set; }
    }
}
