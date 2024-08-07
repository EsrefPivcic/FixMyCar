﻿using AutoMapper;
using FixMyCar.Model.DTOs.CarModel;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class CarModelProfile : Profile
    {
        public CarModelProfile() 
        {
            CreateMap<CarModel, CarModelGetDTO>();
        }
    }
}
