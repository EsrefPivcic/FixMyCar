﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.SearchObjects
{
    public partial class UserSearchObject : BaseSearchObject
    {
        public string? Username { get; set; }
        public string? ContainsUsername { get; set; }
        public bool? Active { get; set; }
        public string? Role { get; set; }
        public int? CityId { get; set; }
    }
}
