using AutoMapper;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Entities;
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

        public async Task<List<StoreItemGetDTO>> Recommend(int storeItemId)
        {
            DataViewSchema modelSchema;
            ITransformer _model = mlContext.Model.Load("model.zip", out modelSchema);
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

            return _mapper.Map<List<StoreItemGetDTO>>(finalResults);
        }
    }
}

