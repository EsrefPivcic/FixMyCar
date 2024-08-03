using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarPartsShopClientDiscount
{
    public class CarPartsShopClientDiscountUpdateDTO
    {
        public double? Value { get; set; }
        public bool? Revoked { get; set; }
    }
}
