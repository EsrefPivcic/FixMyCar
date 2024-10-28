using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Reservation
{
    public class ReservationAvailabilityDTO
    {
        public DateTime Date { get; set; }
        public TimeSpan FreeHours { get; set; }
    }
}
