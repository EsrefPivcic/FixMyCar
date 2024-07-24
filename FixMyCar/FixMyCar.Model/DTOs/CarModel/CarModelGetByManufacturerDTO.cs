using FixMyCar.Model.DTOs.CarManufacturer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarModel
{
    public class CarModelGetByManufacturerDTO
    {
        public CarManufacturerGetDTO Manufacturer { get; set; }
        public List<CarModelGetDTO> Models { get; set; }
    }
}
