using FixMyCar.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services
{
    public class ProductService : IProductService
    {
        List<Product> Products = new List<Product>()
        {
            new Product()
            {
                Id = 1,
                Name = "Test"
            }
        };

        public IList<Product> Get()
        {
            return Products;
        }
    }
}
