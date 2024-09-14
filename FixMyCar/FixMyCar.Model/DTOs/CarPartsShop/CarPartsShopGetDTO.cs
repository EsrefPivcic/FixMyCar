using FixMyCar.Model.DTOs.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarPartsShop
{
    public class CarPartsShopGetDTO : UserGetDTO
    {
        public List<string> WorkDays { get; set; }
        public TimeSpan OpeningTime { get; set; }
        public TimeSpan ClosingTime { get; set; }
        public TimeSpan WorkingHours { get; set; }
    }
}
