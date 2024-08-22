using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.ReservationDetail;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class ReservationDetailController : BaseReadOnlyController<ReservationDetail, ReservationDetailGetDTO, ReservationDetailSearchObject>
    {
        public ReservationDetailController(ILogger<BaseReadOnlyController<ReservationDetail, ReservationDetailGetDTO, ReservationDetailSearchObject>> logger, IReservationDetailService service) : base(logger, service)
        {
        }
    }
}
