using AutoMapper;
using FixMyCar.Model.Utilities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class BaseReadOnlyService<TDb, TGet, TSearch> : IBaseReadOnlyService<TDb, TGet, TSearch> where TDb : class where TGet : class where TSearch : BaseSearchObject
    {
        protected FixMyCarContext _context;
        protected IMapper _mapper;
        public BaseReadOnlyService(FixMyCarContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<PagedResult<TGet>> Get(TSearch? search = null)
        {
            var query = _context.Set<TDb>().AsQueryable();
            query = AddFilter(query, search);
            query = AddInclude(query, search);

            PagedResult<TGet> pagedResult = new PagedResult<TGet>();
            pagedResult.Count = await query.CountAsync();

            if (search?.PageNumber.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Take(search.PageSize.Value).Skip(search.PageNumber.Value * search.PageSize.Value);
            }

            var list = await query.ToListAsync();

            pagedResult.Result = _mapper.Map<List<TGet>>(list);

            return pagedResult;
        }

        public virtual async Task<TGet> GetById(int id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            return _mapper.Map<TGet>(entity);
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }
    }
}
