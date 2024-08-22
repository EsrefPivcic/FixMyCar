using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IReservationService : IBaseService<Reservation, ReservationGetDTO, ReservationInsertDTO, ReservationUpdateDTO, ReservationSearchObject>
    {
    }
}
