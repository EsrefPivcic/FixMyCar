using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarPartsShopClientDiscount
{
    public class CarPartsShopClientDiscountGetDTO
    {
        public int Id { get; set; }
        public string User { get; set; }
        public double Value { get; set; }
        public DateTime Created { get; set; }
        public DateTime? Revoked { get; set; }
    }
}
