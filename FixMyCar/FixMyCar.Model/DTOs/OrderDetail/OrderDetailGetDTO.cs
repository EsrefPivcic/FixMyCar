using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.OrderDetail
{
    public class OrderDetailGetDTO
    {
        public int Id { get; set; }
        public int OrderId { get; set; }
        public int StoreItemId { get; set; }
        public string StoreItemName { get; set; }
        public int Quantity { get; set; }
        public double UnitPrice { get; set; }
        public double TotalItemsPrice { get; set; }
        public double TotalItemsPriceDiscounted { get; set; }
        public double Discount { get; set; }
    }
}
