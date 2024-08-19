using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarRepairShopDiscount
{
    public class CarRepairShopDiscountGetDTO
    {
        public int Id { get; set; }
        public string? Client { get; set; }
        public double Value { get; set; }
        public DateTime Created { get; set; }
        public DateTime? Revoked { get; set; }
    }
}
