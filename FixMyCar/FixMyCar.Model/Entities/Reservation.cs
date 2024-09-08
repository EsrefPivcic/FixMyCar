using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class Reservation
    {
        public int Id { get; set; }
        [ForeignKey(nameof(CarRepairShop))]
        public int CarRepairShopId { get; set; }
        public CarRepairShop CarRepairShop { get; set; }
        [ForeignKey(nameof(Client))]
        public int ClientId { get; set; }
        public Client Client { get; set; }
        [ForeignKey(nameof(Order))]
        public int? OrderId { get; set; }
        public Order? Order { get; set; }
        public bool? ClientOrder { get; set; }
        public DateTime ReservationCreatedDate { get; set; }
        public DateTime ReservationDate { get; set; }
        public DateTime? EstimatedCompletionDate { get; set; }
        public DateTime? CompletionDate { get; set; }
        public double TotalAmount { get; set; }
        public TimeSpan TotalDuration { get; set; }
        [ForeignKey(nameof(CarRepairShopDiscount))]
        public int? CarRepairShopDiscountId { get; set; }
        public CarRepairShopDiscount? CarRepairShopDiscount { get; set; }
        public string State { get; set; }
        public string Type { get; set; }
        public string PaymentMethod { get; set; }
        public ICollection<ReservationDetail> ReservationDetails { get; set; }
    }
}
