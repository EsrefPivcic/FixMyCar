using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.CarModel
{
    public class CarModelGetDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string ModelYear { get; set; }
    }
}
