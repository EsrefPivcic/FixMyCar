using FixMyCar.Model.DTOs.StoreItem;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Order
{
    public class OrderUpdateDTO
    {
        public string? ShippingCity { get; set; }
        public string? ShippingAddress { get; set; }
        public string? ShippingPostalCode { get; set; }
        public string? PaymentMethod { get; set; }
    }
}