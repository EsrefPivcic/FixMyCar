using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Report
{
    public class ReportRequestDTO
    {
        public string? ShopName { get; set; }
        public string? ShopType { get; set; }
        public string? ReservationType { get; set; }
        public string? Username { get; set; }
        public string? Role { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
    }
}