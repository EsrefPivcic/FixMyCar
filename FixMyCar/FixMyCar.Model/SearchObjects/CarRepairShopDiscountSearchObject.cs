using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.SearchObjects
{
    public class CarRepairShopDiscountSearchObject : BaseSearchObject
    {
        public string? ClientName { get; set; }
        public string? CarRepairShopName { get; set; }
        public bool? Active { get; set; }
    }
}