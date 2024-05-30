using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Runtime.CompilerServices;

namespace FixMyCar.Controllers
{
    [ApiController]
    public class ProductController : BaseController<Product, ProductGetDTO, ProductInsertDTO, ProductUpdateDTO, ProductSearchObject>
    {
        public ProductController(IProductService service, ILogger<BaseController<Product, ProductGetDTO, ProductInsertDTO, ProductUpdateDTO, ProductSearchObject>> logger) : base(service, logger)
        {
        }

        [HttpPut("{id}/activate")]
        public virtual async Task<ProductGetDTO> Activate(int id)
        {
            return await (_service as IProductService).Activate(id);
        }

        [HttpPut("{id}/hide")]
        public virtual async Task<ProductGetDTO> Hide(int id)
        {
            return await (_service as IProductService).Hide(id);
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IProductService).AllowedActions(id);
        }
    }
}