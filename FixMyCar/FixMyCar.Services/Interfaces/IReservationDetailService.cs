﻿using FixMyCar.Model.DTOs.ReservationDetail;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IReservationDetailService : IBaseReadOnlyService<ReservationDetail, ReservationDetailGetDTO, ReservationDetailSearchObject>
    {
    }
}
