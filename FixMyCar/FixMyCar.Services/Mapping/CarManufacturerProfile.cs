using AutoMapper;
using FixMyCar.Model.DTOs.CarManufacturer;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    internal class CarManufacturerProfile : Profile
    {
        public CarManufacturerProfile() { 
            CreateMap<CarManufacturer, CarManufacturerGetDTO>();
        }
    }
}
