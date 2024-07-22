using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class CarModel
    {
        public int Id { get; set; }
        [ForeignKey(nameof(CarManufacturer))]
        public int CarManufacturerId { get; set; }
        public CarManufacturer CarManufacturer { get; set; }
        public string Name { get; set; }
        public string ModelYear { get; set; }
        public ICollection<StoreItem> StoreItems { get; set; }
        public ICollection<StoreItemCarModel> StoreItemCarModels { get; set; }
    }
}
