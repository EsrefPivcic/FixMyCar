using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarRepairShopService
{
    public class CarRepairShopServiceInsertDTO
    {
        public string? CarRepairShopName { get; set; }
        [Required]
        public int ServiceTypeId { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public double Price { get; set; }
        [Required]
        public double Discount { get; set; }
        public string? ImageData { get; set; }
        public string? Details { get; set; }
        [Required]
        public TimeSpan Duration { get; set; }
    }
}
