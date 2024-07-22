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
        public double Discount { get; set; }
        public string State { get; set; }
        public byte[]? ImageData { get; set; }
        public string? ImageMimeType { get; set; }
        public string? Details { get; set; }
        public ICollection<StoreItemCarModel> StoreItemCarModels { get; set; }
        public ICollection<CarModel> CarModels { get; set; }
        [ForeignKey(nameof(StoreItemCategory))]
        public int StoreItemCategoryId { get; set; }
        public StoreItemCategory StoreItemCategory { get; set; }
    }
}