using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class StoreItemCarModel
    {
        public int StoreItemId { get; set; }
        public StoreItem StoreItem { get; set; }
        public int CarModelId { get; set; }
        public CarModel CarModel { get; set; }
    }
}
