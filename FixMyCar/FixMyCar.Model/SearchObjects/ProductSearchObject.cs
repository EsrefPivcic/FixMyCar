﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.SearchObjects
{
    public partial class ProductSearchObject : BaseSearchObject
    {
        public string? Starts { get; set; }
        public string? Contains { get; set; }
        public bool? WithDiscount { get; set; }
        public string? State { get; set; }
    }
}