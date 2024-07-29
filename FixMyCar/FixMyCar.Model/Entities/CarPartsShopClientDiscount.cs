using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class CarPartsShopClientDiscount
    {
        public int Id { get; set; }
        [ForeignKey(nameof(CarPartsShop))]
        public int CarPartsShopId { get; set; }
        public CarPartsShop CarPartsShop { get; set; }
        [ForeignKey(nameof(User))]
        public int UserId { get; set; }
        public User User { get; set; }
        public double Value { get; set; }
        public DateTime Created { get; set; }
        public DateTime? Revoked { get; set; }
    }
}
