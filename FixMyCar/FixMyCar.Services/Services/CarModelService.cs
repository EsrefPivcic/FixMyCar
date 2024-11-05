using AutoMapper;
using FixMyCar.Model.DTOs.CarManufacturer;
using FixMyCar.Model.DTOs.CarModel;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class CarModelService : BaseReadOnlyService<CarModel, CarModelGetDTO, CarModelSearchObject>, ICarModelService
    {
        public CarModelService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<PagedResult<CarModelGetByManufacturerDTO>> GetByManufacturerAll()
        {
            var manufacturers = _mapper.Map<List<CarManufacturerGetDTO>>(
                await _context.CarManufacturers
                              .OrderBy(cm => cm.Name)
                              .ToListAsync());

            var manufacturersmodels = new List<CarModelGetByManufacturerDTO>();

            foreach (var manufacturer in manufacturers)
            {
                var manufacturermodels = new CarModelGetByManufacturerDTO()
                {
                    Manufacturer = manufacturer,
                    Models = _mapper.Map<List<CarModelGetDTO>>(
                        await _context.CarModels
                                      .Where(cm => cm.CarManufacturerId == manufacturer.Id)
                                      .OrderBy(cm => cm.Name)
                                      .ToListAsync())
                };

                manufacturersmodels.Add(manufacturermodels);
            }

            PagedResult<CarModelGetByManufacturerDTO> pagedResult = new PagedResult<CarModelGetByManufacturerDTO>
            {
                Result = manufacturersmodels,
                Count = manufacturersmodels.Count
            };

            return pagedResult;
        }
    }
}
