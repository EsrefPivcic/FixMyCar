using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShopService;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.Utilities;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class RecommenderPredictService : IRecommenderPredictService
    {
        protected FixMyCarContext _context;
        static MLContext mlContext = new MLContext();
        protected IMapper _mapper;

        public RecommenderPredictService(FixMyCarContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<PagedResult<StoreItemGetDTO>> RecommendStoreItems(int storeItemId)
        {
            try
            {
                DataViewSchema modelSchema;

                    string modelsPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "RecommenderModels");
                    string ordersModelPath = Path.Combine(modelsPath, "ordersmodel.zip");

                    ITransformer _model = mlContext.Model.Load(ordersModelPath, out modelSchema);
                var storeItems = await _context.StoreItems.Where(x => x.Id != storeItemId).ToListAsync();
                var predictionResult = new List<Tuple<StoreItem, float>>();

                var predictionEngine = mlContext.Model.CreatePredictionEngine<ProductEntry, CopurchasePrediction>(_model);

                foreach (var storeItem in storeItems)
                {
                    var prediction = predictionEngine.Predict(
                                         new ProductEntry()
                                         {
                                             ProductId = (uint)storeItemId,
                                             CoPurchaseProductId = (uint)storeItem.Id
                                         });

                    predictionResult.Add(new Tuple<StoreItem, float>(storeItem, prediction.Score));
                }

                var finalResults = predictionResult.OrderByDescending(x => x.Item2)
                                                   .Select(x => x.Item1)
                                                   .Take(3)
                                                   .ToList();

                PagedResult<StoreItemGetDTO> pagedResult = new PagedResult<StoreItemGetDTO>();

                pagedResult.Result = _mapper.Map<List<StoreItemGetDTO>>(finalResults);
                pagedResult.Count = finalResults.Count;

                return pagedResult;
            }
            catch (Exception)
            {
                throw new UserException("Warning! Recommender is currently not available.");
            }
        }

        public async Task<PagedResult<CarRepairShopServiceGetDTO>> RecommendRepairShopServices(int repairShopServiceId)
        {
            try
            {
                DataViewSchema modelSchema;

                string modelsPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "RecommenderModels");
                string reservationsModelPath = Path.Combine(modelsPath, "reservationsmodel.zip");

                ITransformer _model = mlContext.Model.Load(reservationsModelPath, out modelSchema);
                var repairShopServices = await _context.CarRepairShopServices.Where(x => x.Id != repairShopServiceId).ToListAsync();
                var predictionResult = new List<Tuple<Model.Entities.CarRepairShopService, float>>();

                var predictionEngine = mlContext.Model.CreatePredictionEngine<ProductEntry, CopurchasePrediction>(_model);

                foreach (var repairShopService in repairShopServices)
                {
                    var prediction = predictionEngine.Predict(
                                         new ProductEntry()
                                         {
                                             ProductId = (uint)repairShopServiceId,
                                             CoPurchaseProductId = (uint)repairShopService.Id
                                         });

                    predictionResult.Add(new Tuple<Model.Entities.CarRepairShopService, float>(repairShopService, prediction.Score));
                }

                var finalResults = predictionResult.OrderByDescending(x => x.Item2)
                                                   .Select(x => x.Item1)
                                                   .Take(3)
                                                   .ToList();

                PagedResult<CarRepairShopServiceGetDTO> pagedResult = new PagedResult<CarRepairShopServiceGetDTO>();

                pagedResult.Result = _mapper.Map<List<CarRepairShopServiceGetDTO>>(finalResults);
                pagedResult.Count = finalResults.Count;

                return pagedResult;
            }
            catch (Exception)
            {
                throw new UserException("Warning! Recommender is currently not available.");
            }
        }
    }
}