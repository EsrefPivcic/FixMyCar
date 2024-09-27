using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Payment
{
    public class PaymentCreateDTO
    {
        public long TotalAmount { get; set; }
        public string PaymentMethodId { get; set; }
    }
}
