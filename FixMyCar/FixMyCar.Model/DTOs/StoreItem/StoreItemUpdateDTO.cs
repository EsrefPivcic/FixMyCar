using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Product
{
    public partial class StoreItemUpdateDTO
    {
        public string? Name { get; set; }
        public double? Discount { get; set; }
        public string? ImageData { get; set; }
    }
}