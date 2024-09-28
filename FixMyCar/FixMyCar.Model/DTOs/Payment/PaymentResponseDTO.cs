using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Payment
{
    public class PaymentResponseDTO
    {
        public string PaymentIntentId { get; set; }
        public string Message { get; set; }
    }
}
