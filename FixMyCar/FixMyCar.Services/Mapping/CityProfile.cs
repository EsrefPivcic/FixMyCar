using AutoMapper;
using FixMyCar.Model.DTOs.City;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Mapping
{
    public class CityProfile : Profile
    {
        public CityProfile()
        {
            CreateMap<CityInsertDTO, City>();
            CreateMap<CityUpdateDTO, City>();
            CreateMap<CityGetDTO, City>();
            CreateMap<City, CityInsertDTO>();
            CreateMap<City, CityUpdateDTO>();
            CreateMap<City, CityGetDTO>();
        }
    }
}
