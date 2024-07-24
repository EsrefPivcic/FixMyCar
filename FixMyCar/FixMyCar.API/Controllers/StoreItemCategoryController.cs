using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.StoreItemCategory;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class StoreItemCategoryController : BaseReadOnlyController<StoreItemCategory, StoreItemCategoryGetDTO, StoreItemCategorySearchObject>
    {
        public StoreItemCategoryController(ILogger<BaseReadOnlyController<StoreItemCategory, StoreItemCategoryGetDTO, StoreItemCategorySearchObject>> logger, IStoreItemCategoryService service) : base(logger, service)
        {
        }
    }
}
