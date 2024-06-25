using FixMyCar.Model.DTOs;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IBaseService<TDb, TGet, TInsert, TUpdate, TSearch> : IBaseReadOnlyService<TDb, TGet, TSearch> where TDb : class where TGet : class where TUpdate : class where TInsert : class where TSearch : BaseSearchObject
    {
        Task<TGet> Insert(TInsert request);
        Task<TGet> Update(int id, TUpdate request);
        Task<string> Delete(int id);
        Task BeforeInsert(TDb entity, TInsert insert);
    }
}