using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Order
{
    public class OrderInsertDTO
    {
        public int CarPartsShopId { get; set; }
        public string? Username { get; set; }
        public DateTime OrderDate { get; set; }
        public int CityId { get; set; }
        public string ShippingAddress { get; set; }
        public string ShippingPostalCode { get; set; }
        public string PaymentMethod { get; set; }
        public List<StoreItemOrderDTO> StoreItems { get; set; }
    }
}
