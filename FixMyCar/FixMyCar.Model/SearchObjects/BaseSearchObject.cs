using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.SearchObjects
{
    public class BaseSearchObject
    {
        public int? PageNumber { get; set; }
        public int? PageSize { get; set; }
    }
}
