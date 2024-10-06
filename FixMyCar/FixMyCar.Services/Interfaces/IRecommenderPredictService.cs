using FixMyCar.Model.DTOs.CarRepairShopService;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IRecommenderPredictService
    {
        Task<PagedResult<StoreItemGetDTO>> RecommendStoreItems(int storeItemId);
        Task<PagedResult<CarRepairShopServiceGetDTO>> RecommendRepairShopServices(int repairShopServiceId);
    }
}
