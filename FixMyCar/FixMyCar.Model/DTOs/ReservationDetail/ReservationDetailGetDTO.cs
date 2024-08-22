using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.ReservationDetail
{
    public class ReservationDetailGetDTO
    {
        public int CarRepairShopServiceId { get; set; }
        public string ServiceName { get; set; }
        public double ServicePrice { get; set; }
        public double ServiceDiscount { get; set; }
        public double ServiceDiscountedPrice { get; set; }
    }
}
