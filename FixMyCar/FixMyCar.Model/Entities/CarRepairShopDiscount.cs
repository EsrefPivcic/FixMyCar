﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class CarRepairShopDiscount
    {
        public int Id { get; set; }
        [ForeignKey(nameof(CarRepairShop))]
        public int CarRepairShopId { get; set; }
        public CarRepairShop CarRepairShop { get; set; }
        public double Value { get; set; }
        [ForeignKey(nameof(Client))]
        public int ClientId { get; set; }
        public Client Client { get; set; }
        public DateTime Created { get; set; }
        public DateTime? Revoked { get; set; }
        public bool? SoftDelete { get; set; }
    }
}
