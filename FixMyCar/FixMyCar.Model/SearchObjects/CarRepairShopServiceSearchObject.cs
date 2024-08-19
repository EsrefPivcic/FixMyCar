using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.SearchObjects
{
    public class CarRepairShopServiceSearchObject : BaseSearchObject
    {
        public string? CarRepairShopName { get; set; }
        public string? ServiceType { get; set; }
        public string? Name { get; set; }
        public bool? WithDiscount { get; set; }
        public string? State { get; set; }
    }
}
