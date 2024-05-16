using FixMyCar.Model;
using FixMyCar.Services;
using Microsoft.AspNetCore.Mvc;
using System.Runtime.CompilerServices;

namespace FixMyCar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProductController : ControllerBase
    {
        private readonly IProductService _productService;

        public ProductController(IProductService productService)
        {
            _productService = productService;
        }

        [HttpGet()]
        public IEnumerable<Product> Get()
        {
            return _productService.Get();
        }
    }
}