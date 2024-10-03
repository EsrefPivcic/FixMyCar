using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Payment
{
    public class PaymentCreateDTO
    {
        public int? OrderId { get; set; }
        public int? ReservationId { get; set; }
        public long TotalAmount { get; set; }
        public string? PaymentMethodId { get; set; }
        public string? Username { get; set; }
    }
}
