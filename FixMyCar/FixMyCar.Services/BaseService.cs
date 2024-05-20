using AutoMapper;
using FixMyCar.Model.DTOs;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services
{
    public class BaseService<T, TDb, TSearch> : IBaseService<T, TDb, TSearch> where TDb : class where T : class where TSearch: BaseSearchObject
    {
        FixMyCarContext _context;
        IMapper _mapper;
        public BaseService(FixMyCarContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<PagedResult<T>> Get(TSearch? search = null)
        {
            var query = _context.Set<TDb>().AsQueryable();
            query = AddFilter(query, search);

            PagedResult<T> pagedResult = new PagedResult<T>();
            pagedResult.Count = await query.CountAsync();

            if(search?.PageNumber.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Take(search.PageSize.Value).Skip(search.PageNumber.Value * search.PageSize.Value);
            }

            var list = await query.ToListAsync();

            pagedResult.Result = _mapper.Map<List<T>>(list);

            return pagedResult;
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public async Task <T> Insert(T request)
        {
            var set = _context.Set<TDb>();

            TDb entity = _mapper.Map<TDb>(request);

            await set.AddAsync(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<T>(entity);
        }

        public async Task<T> Update(int id, T request)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<T>(entity);
        }
    }
}