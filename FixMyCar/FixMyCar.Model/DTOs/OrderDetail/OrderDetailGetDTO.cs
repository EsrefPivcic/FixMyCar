using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.OrderDetail
{
    public class OrderDetailGetDTO
    {
        public Entities.Order Order { get; set; }
        public Entities.StoreItem StoreItem { get; set; }
        public int Quantity { get; set; }
        public int UnitPrice { get; set; }
        public int TotalItemsPrice { get; set; }
        public double? Discount { get; set; }
    }
}
