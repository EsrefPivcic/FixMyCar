using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Utilities
{
    public class Validation
    {
        public static bool IsReservationOnWorkday(DateTime reservationDate, CarRepairShop repairShop)
        {
            DayOfWeek reservationDay = reservationDate.DayOfWeek;

            return repairShop.WorkDays.Contains(reservationDay);
        }

        public static bool IsWithinWorkHours(TimeSpan reservationDuration, TimeSpan repairShopEmployeeWorkHours, List<Reservation> reservations)
        {
            TimeSpan duration = TimeSpan.Zero;
            foreach (Reservation reservation in reservations) 
            {
                duration += reservation.TotalDuration;
            }
            duration += reservationDuration;

            if (duration <= repairShopEmployeeWorkHours)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
