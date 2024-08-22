using AutoMapper;
using FixMyCar.Model.DTOs.Reservation;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class ReservationService : BaseService<Reservation, ReservationGetDTO, ReservationInsertDTO, ReservationUpdateDTO, ReservationSearchObject>, IReservationService
    {
        public ReservationService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
