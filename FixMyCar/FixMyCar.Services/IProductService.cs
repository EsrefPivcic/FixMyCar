using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;

namespace FixMyCar.Services
{
    public interface IProductService
    {
        IList<Product> Get();
        Product Insert(ProductInsertDTO request);
        Product Update(int id, ProductUpdateDTO request);
    }
}
