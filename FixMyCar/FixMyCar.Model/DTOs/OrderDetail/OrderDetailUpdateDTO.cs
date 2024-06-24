using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.OrderDetail
{
    public class OrderDetailUpdateDTO
    {
        public int StoreItemId { get; set; }
        public int Quantity { get; set; }
        public int UnitPrice { get; set; }
        public int TotalItemsPrice { get; set; }
        public double? Discount { get; set; }
    }
}
