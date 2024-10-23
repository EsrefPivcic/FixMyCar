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
    public class CarRepairShopGetDTO : UserGetDTO
    {
        public List<string> WorkDays { get; set; }
        public TimeSpan OpeningTime { get; set; }
        public TimeSpan ClosingTime { get; set; }
        public TimeSpan WorkingHours { get; set; }
        public int Employees { get; set; }
    }
}
