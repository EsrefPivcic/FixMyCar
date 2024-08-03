using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace FixMyCar.Model.SearchObjects
{
    public class CarPartsShopClientDiscountSearchObject : BaseSearchObject
    {
        public string? CarPartsShopName { get; set; }
        public string? Role { get; set; }
        public bool? Active { get; set; }
    }
}
