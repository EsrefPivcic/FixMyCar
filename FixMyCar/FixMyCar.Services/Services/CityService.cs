using AutoMapper;
using FixMyCar.Model.DTOs.City;
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
    public class CityService : BaseService<City, CityGetDTO, CityInsertDTO, CityUpdateDTO, CitySearchObject>, ICityService
    {
        public CityService(FixMyCarContext context, IMapper mapper) : base (context, mapper) { }
    }
}
