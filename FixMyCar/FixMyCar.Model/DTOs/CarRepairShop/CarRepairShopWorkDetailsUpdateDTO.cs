using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarRepairShop
{
    public class CarRepairShopWorkDetailsUpdateDTO
    {
        public string? Username { get; set; }
        public List<DayOfWeek> WorkDays { get; set; }
        public string OpeningTime { get; set; }
        public string ClosingTime { get; set; }
        public int Employees { get; set; }
    }
}
