using AutoMapper;
using FixMyCar.Model.DTOs.ReservationDetail;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class ReservationDetailProfile : Profile
    {
        public ReservationDetailProfile() 
        {
            CreateMap<ReservationDetail, ReservationDetailGetDTO>();
        }
    }
}
