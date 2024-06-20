using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Runtime.CompilerServices;

namespace FixMyCar.Controllers
{
    [ApiController]
    public class StoreItemController : BaseController<StoreItem, StoreItemGetDTO, StoreItemInsertDTO, StoreItemUpdateDTO, StoreItemSearchObject>
    {
        public StoreItemController(IStoreItemService service, ILogger<BaseController<StoreItem, StoreItemGetDTO, StoreItemInsertDTO, StoreItemUpdateDTO, StoreItemSearchObject>> logger) : base(service, logger)
        {
        }

        [HttpPut("{id}/activate")]
        public virtual async Task<StoreItemGetDTO> Activate(int id)
        {
            return await (_service as IStoreItemService).Activate(id);
        }

        [HttpPut("{id}/hide")]
        public virtual async Task<StoreItemGetDTO> Hide(int id)
        {
            return await (_service as IStoreItemService).Hide(id);
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IStoreItemService).AllowedActions(id);
        }
    }
}