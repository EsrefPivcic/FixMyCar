using FixMyCar.API.SignalR;
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
        private readonly NotificationService _notificationService;
        public StoreItemController(IStoreItemService service, ILogger<BaseController<StoreItem, StoreItemGetDTO, StoreItemInsertDTO, StoreItemUpdateDTO, StoreItemSearchObject>> logger, NotificationService notificationService) : base(service, logger)
        {
            _notificationService = notificationService;
        }

        [HttpPut("{id}/Activate")]
        public virtual async Task<StoreItemGetDTO> Activate(int id)
        {
            try
            {
                var activatedStoreItem = await (_service as IStoreItemService).Activate(id);

                var message = $"New product ({activatedStoreItem.Name}) available in store: {activatedStoreItem.CarPartsShopName}.";

                await _notificationService.SendServiceNotification(message, "newstoreitem");

                return activatedStoreItem;
            }
            catch (UserException)
            {

                throw;
            }
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