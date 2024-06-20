using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class ClientDiscount
    {
        public int Id { get; set; }
        [ForeignKey(nameof(User))]
        public int UserId { get; set; }
        public User User { get; set; }
        [ForeignKey(nameof(CarPartsShop))]
        public int? CarPartsShopId { get; set; }
        public CarPartsShop? CarPartsShop { get; set; }
        [ForeignKey(nameof(CarServiceShop))]
        public int? CarServiceShopId { get; set; }
        public CarServiceShop? CarServiceShop { get; set; }
        [ForeignKey(nameof(Discount))]
        public int DiscountId { get; set; }
        public Discount Discount { get; set; }
        public DateTime Created { get; set; }
        public DateTime? Revoked { get; set; }
    }
}
