using FixMyCar.Model.DTOs.Product;
using FixMyCar.Services;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.Controllers
{
    [Route("[controller]")]
    public class BaseController<T> : ControllerBase where T : class
    {
        private readonly IBaseService<T> _service;
        private readonly ILogger<BaseController<T>> _logger;

        public BaseController(IBaseService<T> service, ILogger<BaseController<T>> logger)
        {
            _service = service;
            _logger = logger;
        }

        [HttpGet()]
        public async Task<List<T>> Get()
        {
            return await _service.Get();
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