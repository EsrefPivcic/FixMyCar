using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarPartsShopClientDiscount
{
    public class CarPartsShopClientDiscountInsertDTO
    {
        public int UserId { get; set; }
        public string? Username { get; set; }
        public double Value { get; set; }
    }
}
