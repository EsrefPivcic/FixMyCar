﻿using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Order
{
    public class OrderGetDTO
    {
        public int Id { get; set; }
        public string CarPartsShopName { get; set; }
        public string Username { get; set; }
        public DateTime OrderDate { get; set; }
        public DateTime? ShippingDate { get; set; }
        public double TotalAmount { get; set; }
        public double ClientDiscountValue { get; set; }
        public string State { get; set; }
        public int CityId { get; set; }
        public string ShippingCity { get; set; }
        public string ShippingAddress { get; set; }
        public string ShippingPostalCode { get; set; }
    }
}