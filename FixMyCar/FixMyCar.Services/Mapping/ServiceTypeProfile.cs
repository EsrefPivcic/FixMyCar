using AutoMapper;
using FixMyCar.Model.DTOs.ServiceType;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class ServiceTypeProfile : Profile
    {
        public ServiceTypeProfile() {
            CreateMap<ServiceType, ServiceTypeGetDTO>()
                .ForMember(dest => dest.Image, opt => opt.MapFrom(src => src.Image != null ? Convert.ToBase64String(src.Image) : string.Empty));
        }
    }
}
