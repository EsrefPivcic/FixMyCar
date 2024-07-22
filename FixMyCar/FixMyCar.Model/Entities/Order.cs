using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class Order
    {
        public int Id { get; set; }
        [ForeignKey(nameof(User))]
        public int UserId { get; set; }
        public User User { get; set; }
        [ForeignKey(nameof(CarRepairShop))]
        public int CarRepairShopId { get; set; }
        public CarRepairShop CarRepairShop { get; set; }
        public DateTime OrderDate { get; set; }
        public DateTime ShippingDate { get; set; }
        public double TotalAmount { get; set; }
        [ForeignKey(nameof(ClientDiscount))]
        public int? ClientDiscountId { get; set; }
        public ClientDiscount? ClientDiscount { get; set; }
        public string State { get; set; }
        public string ShippingCity { get; set; }
        public string ShippingAddress { get; set; }
        public string ShippingPostalCode { get; set; }
        public string PaymentMethod { get; set; }
    }
}
