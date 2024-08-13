using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class CarRepairShopService
    {
        public int Id { get; set; }
        [ForeignKey(nameof(CarRepairShop))]
        public int CarRepairShopId { get; set; }
        public CarRepairShop CarRepairShop { get; set; }
        [ForeignKey(nameof(ServiceType))]
        public int ServiceTypeId { get; set; }
        public ServiceType ServiceType { get; set; }
        public string Name { get; set; }
        public double Price { get; set; }
        public double Discount { get; set; }
        public double DiscountedPrice { get; set; }
        public string State { get; set; }
        public byte[]? ImageData { get; set; }
        public string? Details { get; set; }
        public TimeSpan Duration { get; set; }
    }
}
