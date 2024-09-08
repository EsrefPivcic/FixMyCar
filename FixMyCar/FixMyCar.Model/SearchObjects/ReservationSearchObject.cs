using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.SearchObjects
{
    public class ReservationSearchObject : BaseSearchObject
    {
        public string? CarRepairShopName { get; set; }
        public bool? Discount { get; set; }
        public string? State { get; set; }
        public string? Type { get; set; }
        public double? MinTotalAmount { get; set; }
        public double? MaxTotalAmount { get; set; }
        public bool? ClientOrder { get; set; }
        public DateTime? MinCreatedDate { get; set; }
        public DateTime? MaxCreatedDate { get; set; }
        public DateTime? MinReservationDate { get; set; }
        public DateTime? MaxReservationDate { get; set; }
        public DateTime? MinEstimatedCompletionDate { get; set; }
        public DateTime? MaxEstimatedCompletionDate { get; set; }
        public DateTime? MinCompletionDate { get; set; }
        public DateTime? MaxCompletionDate { get; set; }
    }
}
