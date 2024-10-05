using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.Utilities;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Trainers;

namespace FixMyCar.Services.Services
{
    public class RecommenderTrainService : IRecommenderTrainService
    {
        protected FixMyCarContext _context;
        static MLContext mlContext = new MLContext();
        private static object isLocked = new object();

        public RecommenderTrainService(FixMyCarContext context)
        {
            _context = context;
        }

        public void TrainModel()
        {
            lock (isLocked)
            {
                var orders = _context.Orders.Include("OrderDetails").ToList();
                var data = new List<ProductEntry>();
                ITransformer model = null;

                foreach (var order in orders)
                {
                    if (order.OrderDetails.Count > 1)
                    {
                        var orderDetailsStoreItemIds = order.OrderDetails.Select(od => od.StoreItemId).ToList();

                        orderDetailsStoreItemIds.ForEach(storeItemId =>
                        {
                            var relatedItems = order.OrderDetails.Where(od => od.StoreItemId != storeItemId);

                            foreach (var relatedItem in relatedItems)
                            {
                                data.Add(new ProductEntry()
                                {
                                    ProductId = (uint)storeItemId,
                                    CoPurchaseProductId = (uint)relatedItem.StoreItemId,
                                });
                            }
                        });
                    }

                }

                var trainData = mlContext.Data.LoadFromEnumerable(data);

                MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options
                {
                    MatrixColumnIndexColumnName = nameof(ProductEntry.ProductId),
                    MatrixRowIndexColumnName = nameof(ProductEntry.CoPurchaseProductId),
                    LabelColumnName = "Label",
                    LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                    Alpha = 0.01,
                    Lambda = 0.025,
                    NumberOfIterations = 100,
                    C = 0.00001
                };

                var trainer = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                model = trainer.Fit(trainData);

                mlContext.Model.Save(model, trainData.Schema, "model.zip");
            }
        }
    }
}