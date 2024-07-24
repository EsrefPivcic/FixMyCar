using FixMyCar.Model.DTOs.CarModel;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface ICarModelService : IBaseReadOnlyService<CarModel, CarModelGetDTO, CarModelSearchObject>
    {
        Task<PagedResult<CarModelGetByManufacturerDTO>> GetByManufacturerAll();
    }
}
