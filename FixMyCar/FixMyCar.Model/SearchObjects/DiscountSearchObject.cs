using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public partial class DiscountSearchObject : BaseSearchObject
    {
        public float? Value { get; set; }
    }
}
