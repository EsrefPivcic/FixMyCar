using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.API.Controllers
{
    [Authorize]
    [ApiController]
    public class RecommenderController : ControllerBase
    {
        private readonly IRecommenderTrainService _recommenderTrainService;
        private readonly IRecommenderPredictService _recommenderPredictService;
        public RecommenderController(IRecommenderTrainService recommenderTrainService, IRecommenderPredictService recommenderPredictService)
        {
            _recommenderTrainService = recommenderTrainService;
            _recommenderPredictService = recommenderPredictService;
        }

        [HttpPost("Train")]
        public IActionResult Train()
        {
            _recommenderTrainService.TrainModel();
            return Ok();
        }

        [HttpGet("Predict/{storeItemId}")]
        public async Task<List<StoreItemGetDTO>> Predict(int storeItemId)
        {
            return await _recommenderPredictService.Recommend(storeItemId);
        }
    }
}
