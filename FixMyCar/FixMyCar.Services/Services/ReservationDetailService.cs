using AutoMapper;
using FixMyCar.Model.DTOs.ReservationDetail;
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
    public class ReservationDetailService : BaseReadOnlyService<ReservationDetail, ReservationDetailGetDTO, ReservationDetailSearchObject>, IReservationDetailService
    {
        public ReservationDetailService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<ReservationDetail> AddFilter(IQueryable<ReservationDetail> query, ReservationDetailSearchObject? search = null)
        {
            if (search != null)
            {
                if (search?.ReservationId != null)
                {
                    query = query.Where(od => od.ReservationId == search.ReservationId);
                }
            }
            return base.AddFilter(query, search);
        }
    }
}
