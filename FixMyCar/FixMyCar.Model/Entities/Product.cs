using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public partial class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        [ForeignKey(nameof(Discount))]
        public int? DicountId { get; set; }
        public Discount? Discount { get; set; }
    }
}