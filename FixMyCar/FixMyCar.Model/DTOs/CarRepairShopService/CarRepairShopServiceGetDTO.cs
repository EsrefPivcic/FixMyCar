using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarRepairShopService
{
    public class CarRepairShopServiceGetDTO
    {
        public int Id { get; set; }
        public string CarRepairShopName { get; set; }
        public string ServiceTypeName { get; set; }
        public string Name { get; set; }
        public double Price { get; set; }
        public double Discount { get; set; }
        public double DiscountedPrice { get; set; }
        public string State { get; set; }
        public string? ImageData { get; set; }
        public string? Details { get; set; }
        public TimeSpan Duration { get; set; }
    }
}
