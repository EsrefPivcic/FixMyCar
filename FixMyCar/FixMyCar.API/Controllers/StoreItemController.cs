using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Runtime.CompilerServices;
using System.Security.Claims;

namespace FixMyCar.Controllers
{
    [ApiController]
    public class StoreItemController : BaseController<StoreItem, StoreItemGetDTO, StoreItemInsertDTO, StoreItemUpdateDTO, StoreItemSearchObject>
    {
        public StoreItemController(IStoreItemService service, ILogger<BaseController<StoreItem, StoreItemGetDTO, StoreItemInsertDTO, StoreItemUpdateDTO, StoreItemSearchObject>> logger) : base(service, logger)
        {
        }

        [HttpPut("{id}/Activate")]
        public virtual async Task<StoreItemGetDTO> Activate(int id)
        {
            return await (_service as IStoreItemService).Activate(id);
        }

        [HttpPut("{id}/Hide")]
        public virtual async Task<StoreItemGetDTO> Hide(int id)
        {
            return await (_service as IStoreItemService).Hide(id);
        }

        [HttpGet("{id}/AllowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IStoreItemService).AllowedActions(id);
        }

        [HttpPost()]
        public async override Task<StoreItemGetDTO> Insert(StoreItemInsertDTO request)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            request.Username = username;
            return await (_service as IStoreItemService).Insert(request);
        }

        [HttpGet("GetByToken")]
        public async Task<PagedResult<StoreItemGetDTO>> GetByToken([FromQuery] StoreItemSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.CarPartsShopName = username;
            return await (_service as IStoreItemService).Get(search);
        }
    }
}