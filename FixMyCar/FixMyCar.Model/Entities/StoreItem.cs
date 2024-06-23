using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public partial class StoreItem
    {
        public int Id { get; set; }
        public string Name { get; set; }
        [ForeignKey(nameof(Discount))]
        public double Discount { get; set; }
        public string State { get; set; }
        public byte[]? ImageData { get; set; }
        public string? ImageMimeType { get; set; }
    }
}