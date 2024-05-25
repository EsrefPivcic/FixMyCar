using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Discount
{
    public class DiscountInsertDTO
    {
        [Required(AllowEmptyStrings = false)]
        public float Value { get; set; }
    }
}
