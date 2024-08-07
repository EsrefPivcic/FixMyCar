﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Order
{
    public class OrderUpdateDTO
    {
        public int UserId { get; set; }
        public int? CarRepairShopId { get; set; }
        public DateTime OrderDate { get; set; }
        public DateTime ShippingDate { get; set; }
        public double TotalAmount { get; set; }
        public int? ClientDiscountId { get; set; }
        public string State { get; set; }
        public string ShippingCity { get; set; }
        public string ShippingAddress { get; set; }
        public string ShippingPostalCode { get; set; }
        public string PaymentMethod { get; set; }
    }
}
