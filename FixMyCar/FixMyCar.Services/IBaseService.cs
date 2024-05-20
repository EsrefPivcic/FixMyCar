using FixMyCar.Model.DTOs;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services
{
    public interface IBaseService<T, TDb, TSearch> where T : class where TDb : class where TSearch : BaseSearchObject
    {
        Task<PagedResult<T>> Get(TSearch search = null);
        IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch? search = null);
        Task<T> Insert(T request);
        Task<T> Update(int id, T request);
    }
}