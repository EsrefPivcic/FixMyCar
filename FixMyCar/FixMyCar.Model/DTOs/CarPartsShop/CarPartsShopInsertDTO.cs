using FixMyCar.Model.DTOs.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarPartsShop
{
    public class CarPartsShopInsertDTO : UserInsertDTO
    {
        public List<DayOfWeek> WorkDays { get; set; }
        public string OpeningTime { get; set; }
        public string ClosingTime { get; set; }
    }
}
