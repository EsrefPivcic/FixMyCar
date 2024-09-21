using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.SearchObjects
{
    public class OrderSearchObject : BaseSearchObject
    {
        public string? CarPartsShopName { get; set; }
        public string? CarRepairShopName { get; set; }
        public string? ClientName { get; set; }
        public string? Role { get; set; }
        public bool? Discount { get; set; }
        public string? State { get; set; }
        public double? MinTotalAmount { get; set; }
        public double? MaxTotalAmount { get; set; }
        public DateTime? MinOrderDate { get; set; }
        public DateTime? MaxOrderDate { get; set; }
        public DateTime? MinShippingDate { get; set; }
        public DateTime? MaxShippingDate { get; set; }
    }
}
