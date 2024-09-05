using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Order
{
    public class OrderBasicInfoGetDTO
    {
        public string CarPartsShopName { get; set; }
        public string Username { get; set; }
        public DateTime OrderDate { get; set; }
        public DateTime? ShippingDate { get; set; }
        public string State { get; set; }
        public List<string> Items { get; set; }
    }
}