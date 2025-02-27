﻿using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Reservation
{
    public class ReservationInsertDTO
    {
        public string? ClientUsername { get; set; }
        public int CarRepairShopId { get; set; }
        public int CarModelId { get; set; }
        public int? OrderId { get; set; }
        public bool? ClientOrder { get; set; }
        public DateTime ReservationDate { get; set; }
        public List<int> Services { get; set; }
    }
}
