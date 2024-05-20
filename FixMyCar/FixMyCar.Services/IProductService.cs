using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;

namespace FixMyCar.Services
{
    public interface IProductService : IBaseService<ProductGetDTO, Product, ProductSearchObject>
    {       
    }
}