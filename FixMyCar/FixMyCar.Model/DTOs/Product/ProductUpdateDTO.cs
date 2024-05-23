using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Product
{
    public partial class ProductUpdateDTO
    {
        public string? Name { get; set; }
        public int? DicountId { get; set; }
    }
}