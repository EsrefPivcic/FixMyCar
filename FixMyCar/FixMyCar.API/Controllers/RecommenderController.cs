using FixMyCar.Model.DTOs.CarRepairShopService;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class RecommenderController : ControllerBase
    {
        private readonly IRecommenderTrainService _recommenderTrainService;
        private readonly IRecommenderPredictService _recommenderPredictService;
        public RecommenderController(IRecommenderTrainService recommenderTrainService, IRecommenderPredictService recommenderPredictService)
        {
            _recommenderTrainService = recommenderTrainService;
            _recommenderPredictService = recommenderPredictService;
        }

        [HttpPost("TrainOrdersModel")]
        public IActionResult TrainOrdersModel()
        {
            _recommenderTrainService.TrainOrdersModel();
            return Ok();
        }

        [HttpPost("TrainReservationsModel")]
        public IActionResult TrainReservationsModel()
        {
            _recommenderTrainService.TrainReservationsModel();
            return Ok();
        }

        [HttpGet("RecommendStoreItems/{storeItemId}")]
        public async Task<PagedResult<StoreItemGetDTO>> RecommendStoreItems(int storeItemId)
        {
            return await _recommenderPredictService.RecommendStoreItems(storeItemId);
        }

        [HttpGet("RecommendRepairShopServices/{carRepairShopServiceId}")]
        public async Task<PagedResult<CarRepairShopServiceGetDTO>> RecommendRepairShopServices(int carRepairShopServiceId)
        {
            return await _recommenderPredictService.RecommendRepairShopServices(carRepairShopServiceId);
        }
    }
}
