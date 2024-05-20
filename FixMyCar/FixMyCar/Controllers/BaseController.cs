using FixMyCar.Model.DTOs;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.Controllers
{
    [Route("[controller]")]
    public class BaseController<T, TDb, TSearch> : ControllerBase where T : class where TDb: class where TSearch : BaseSearchObject
    {
        private readonly IBaseService<T, TDb, TSearch> _service;
        private readonly ILogger<BaseController<T, TDb, TSearch>> _logger;
        
        public BaseController(IBaseService<T, TDb, TSearch> service, ILogger<BaseController<T, TDb, TSearch>> logger)
        {
            _service = service;
            _logger = logger;
        }

        [HttpGet()]
        public async Task<PagedResult<T>> Get([FromQuery]TSearch? search = null)
        {
            return await _service.Get(search);
        }

        [HttpPost()]
        public async Task<T> Insert(T request)
        {
            return await _service.Insert(request);
        }

        [HttpPut("{id}")]
        public async Task<T> Update(int id, T request)
        {
            return await _service.Update(id, request);
        }
    }
}