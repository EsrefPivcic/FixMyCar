using FixMyCar.Model.DTOs;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.Controllers
{
    [Route("[controller]")]
    public class BaseController<TDb, TGet, TInsert, TUpdate, TSearch> : ControllerBase where TGet : class where TDb : class where TUpdate : class where TInsert : class where TSearch : BaseSearchObject
    {
        private readonly IBaseService<TDb, TGet, TInsert, TUpdate, TSearch> _service;
        private readonly ILogger<BaseController<TDb, TGet, TInsert, TUpdate, TSearch>> _logger;
        
        public BaseController(IBaseService<TDb, TGet, TInsert, TUpdate, TSearch> service, ILogger<BaseController<TDb, TGet, TInsert, TUpdate, TSearch>> logger)
        {
            _service = service;
            _logger = logger;
        }

        [HttpGet()]
        public async Task<PagedResult<TGet>> Get([FromQuery]TSearch? search = null)
        {
            return await _service.Get(search);
        }

        [HttpPost()]
        public async Task<TGet> Insert(TInsert request)
        {
            return await _service.Insert(request);
        }

        [HttpPut("{id}")]
        public async Task<TGet> Update(int id, TUpdate request)
        {
            return await _service.Update(id, request);
        }
    }
}