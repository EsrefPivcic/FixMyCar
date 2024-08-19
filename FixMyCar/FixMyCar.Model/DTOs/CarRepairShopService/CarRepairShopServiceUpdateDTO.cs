using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarRepairShopService
{
    public class CarRepairShopServiceUpdateDTO
    {
        public int? ServiceTypeId { get; set; }
        public string? Name { get; set; }
        public double? Price { get; set; }
        public double? Discount { get; set; }
        public string? ImageData { get; set; }
        public string? Details { get; set; }
        public string? Duration { get; set; }
    }
}
