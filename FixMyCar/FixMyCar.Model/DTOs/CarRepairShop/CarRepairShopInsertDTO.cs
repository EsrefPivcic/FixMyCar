using FixMyCar.Model.DTOs.User;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarRepairShop
{
    public class CarRepairShopInsertDTO : UserInsertDTO
    {
        public List<DayOfWeek> WorkDays { get; set; }
        public string OpeningTime { get; set; }
        public string ClosingTime { get; set; }
        public int Employees { get; set; }
    }
}
