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
        [ForeignKey(nameof(CarPartsShop))]
        public int CarPartsShopId { get; set; }
        public CarPartsShop CarPartsShop { get; set; }
        [ForeignKey(nameof(CarRepairShop))]
        public int? CarRepairShopId { get; set; }
        public CarRepairShop? CarRepairShop { get; set; }
        [ForeignKey(nameof(Client))]
        public int? ClientId { get; set; }
        public Client? Client { get; set; }
        public DateTime OrderDate { get; set; }
        public DateTime? ShippingDate { get; set; }
        public double TotalAmount { get; set; }
        [ForeignKey(nameof(ClientDiscount))]
        public int? ClientDiscountId { get; set; }
        public CarPartsShopClientDiscount? ClientDiscount { get; set; }
        public string State { get; set; }
        [ForeignKey(nameof(City))]
        public int CityId { get; set; }
        public City City { get; set; }
        public string ShippingAddress { get; set; }
        public string ShippingPostalCode { get; set; }
        public string? PaymentIntentId { get; set; }
        public ICollection<OrderDetail> OrderDetails { get; set; }
    }
}
