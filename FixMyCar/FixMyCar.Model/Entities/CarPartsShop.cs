using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class CarPartsShop : User
    {
        [NotMapped]
        public List<DayOfWeek> WorkDays { get; set; }

        public string WorkDaysAsString
        {
            get => WorkDays != null ? string.Join(",", WorkDays.Select(d => (int)d)) : string.Empty;
            set => WorkDays = !string.IsNullOrEmpty(value) ? value.Split(',').Select(int.Parse).Select(d => (DayOfWeek)d).ToList() : new List<DayOfWeek>();
        }

        public TimeSpan OpeningTime { get; set; }
        public TimeSpan ClosingTime { get; set; }
        public TimeSpan WorkingHours { get; set; }
    }
}
