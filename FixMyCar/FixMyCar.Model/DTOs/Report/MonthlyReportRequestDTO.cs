using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Report
{
    public class MonthlyReportRequestDTO
    {
        public int ShopId { get; set; }
        public string ShopName { get; set; }
        public string ShopType { get; set; }
    }
}
