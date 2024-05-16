using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FixMyCar.Model;

namespace FixMyCar.Services
{
    public interface IProductService
    {
        IList<Product> Get();
    }
}
