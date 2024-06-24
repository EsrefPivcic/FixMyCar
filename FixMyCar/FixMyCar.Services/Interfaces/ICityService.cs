using FixMyCar.Model.DTOs.City;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface ICityService : IBaseService<City, CityGetDTO, CityInsertDTO, CityUpdateDTO, CitySearchObject>
    {
    }
}
