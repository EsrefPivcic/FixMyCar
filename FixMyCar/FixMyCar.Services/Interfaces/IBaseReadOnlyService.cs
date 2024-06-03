using FixMyCar.Model.Utilities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IBaseReadOnlyService<TDb, TGet, TSearch> where TDb : class where TGet : class where TSearch : BaseSearchObject
    {
        Task<PagedResult<TGet>> Get(TSearch? search = null);
        Task<TGet> GetById(int id);
        IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch? search = null);
        IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null);
    }
}
