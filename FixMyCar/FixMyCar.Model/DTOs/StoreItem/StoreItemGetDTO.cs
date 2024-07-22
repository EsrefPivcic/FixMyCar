using FixMyCar.Model.DTOs.CarModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Product
{
    public partial class StoreItemGetDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string State { get; set; }
        public double? Discount { get; set; }
        public string? ImageData { get; set; }
        public string? ImageMimeType { get; set; }
        public string Details { get; set; }
        public ICollection<CarModelGetDTO> CarModels { get; set; }
        public int StoreItemCategoryId { get; set; }
        public string Category { get; set; }
    }
}