using FixMyCar.Model.DTOs;
using FixMyCar.Model.DTOs.StoreItem;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FixMyCar.Controllers
{
    [Route("[controller]")]
    public class BaseController<TDb, TGet, TInsert, TUpdate, TSearch> : BaseReadOnlyController<TDb, TGet, TSearch> where TGet : class where TDb : class where TUpdate : class where TInsert : class where TSearch : BaseSearchObject
    {
        protected new readonly IBaseService<TDb, TGet, TInsert, TUpdate, TSearch> _service;
        protected new readonly ILogger<BaseController<TDb, TGet, TInsert, TUpdate, TSearch>> _logger;
        
        public BaseController(IBaseService<TDb, TGet, TInsert, TUpdate, TSearch> service, ILogger<BaseController<TDb, TGet, TInsert, TUpdate, TSearch>> logger) : base(logger, service)
        {
            _service = service;
            _logger = logger;
        }

        [HttpPost()]
        public async virtual Task<TGet> Insert(TInsert request)
        {
            return await _service.Insert(request);
        }

        [HttpPut("{id}")]
        public async Task<TGet> Update(int id, TUpdate request)
        {
            return await _service.Update(id, request);
        }

        [HttpDelete("{id}")]
        public async Task<string> Delete(int id)
        {
            return await _service.Delete(id);
        }
    }
}