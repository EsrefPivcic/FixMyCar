using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Product
{
    public partial class ProductGetDTO
    {
        public string Name { get; set; }
        public Entities.Discount? Discount { get; set; }
    }
}