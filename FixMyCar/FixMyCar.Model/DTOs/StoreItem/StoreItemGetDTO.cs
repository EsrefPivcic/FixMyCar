using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Product
{
    public partial class StoreItemGetDTO
    {
        public string Name { get; set; }
        public string State { get; set; }
        public Entities.Discount? Discount { get; set; }
        public string? ImageData { get; set; }
        public string? ImageMimeType { get; set; }
    }
}