using FixMyCar.Model.DTOs.StoreItem;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IRecommenderPredictService
    {
        Task<List<StoreItemGetDTO>> Recommend(int storeItemId);
    }
}
