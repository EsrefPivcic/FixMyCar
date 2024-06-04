﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Product
{
    public partial class ProductInsertDTO
    {
        [Required(AllowEmptyStrings = false)]
        public string Name { get; set; }
    }
}