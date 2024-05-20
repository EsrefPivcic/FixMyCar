using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services;
using Microsoft.AspNetCore.Mvc;
using System.Runtime.CompilerServices;

namespace FixMyCar.Controllers
{
    [ApiController]
    public class ProductController : BaseController<ProductGetDTO, Product, ProductSearchObject>
    {
        public ProductController(IProductService service, ILogger<BaseController<ProductGetDTO, Product, ProductSearchObject>> logger) : base(service, logger)
        {
        }
    }
}