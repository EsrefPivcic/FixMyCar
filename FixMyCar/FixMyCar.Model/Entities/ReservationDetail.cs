using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class ReservationDetail
    {
        public int Id { get; set; }
        [ForeignKey(nameof(Reservation))]
        public int ReservationId { get; set; }
        public Reservation Reservation { get; set; }
        [ForeignKey(nameof(CarRepairShopService))]
        public int CarRepairShopServiceId { get; set; }
        public CarRepairShopService CarRepairShopService { get; set; }
        public string ServiceName { get; set; }
        public double ServicePrice { get; set; }
        public double ServiceDiscount { get; set; }
        public double ServiceDiscountedPrice { get; set; }
    }
}
