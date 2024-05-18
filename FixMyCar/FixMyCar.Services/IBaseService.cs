using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services
{
    public interface IBaseService<T> where T : class
    {
        Task<List<T>> Get();
        Task<T> Insert(T request);
        Task<T> Update(int id, T request);
    }
}