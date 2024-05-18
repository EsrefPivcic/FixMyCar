using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Services;
using Microsoft.AspNetCore.Mvc;
using System.Runtime.CompilerServices;

namespace FixMyCar.Controllers
{
    [ApiController]
    public class ProductController : BaseController<ProductGetDTO>
    {
        public ProductController(IProductService service, ILogger<BaseController<ProductGetDTO>> logger) : base(service, logger)
        {
        }
    }
}