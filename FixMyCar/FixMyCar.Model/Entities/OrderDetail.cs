using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class OrderDetail
    {
        public int Id { get; set; }
        [ForeignKey(nameof(Order))]
        public int OrderId { get; set; }
        public Order Order { get; set; }
        [ForeignKey(nameof(StoreItem))]
        public int StoreItemId { get; set; }
        public StoreItem StoreItem { get; set; }
        public int Quantity { get; set; }
        public double UnitPrice { get; set; }
        public double TotalItemsPrice { get; set; }
        public double TotalItemsPriceDiscounted { get; set; }
        public double Discount { get; set; }
    }
}
