using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarRepairShop
{
    public class CarRepairShopUpdateDTO
    {
        public string? Name { get; set; }
        public int? CityId { get; set; }
        public string? Address { get; set; }
        public string? PostalCode { get; set; }
        public string? Phone { get; set; }
        public byte[]? Logo { get; set; }
    }
}
