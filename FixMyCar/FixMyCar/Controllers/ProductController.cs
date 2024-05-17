using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
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

        [HttpPost()]
        public Product Insert(ProductInsertDTO request)
        {
            return _productService.Insert(request);
        }

        [HttpPut("{id}")]
        public Product Update(int id, ProductUpdateDTO request)
        {
            return _productService.Update(id, request);
        }
    }
}