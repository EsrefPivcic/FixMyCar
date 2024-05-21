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

namespace FixMyCar.Services.Services
{
    public class BaseService<TDb, TGet, TInsert, TUpdate, TSearch> : BaseReadOnlyService<TDb, TGet, TSearch> where TGet : class where TDb : class where TUpdate : class where TInsert : class where TSearch : BaseSearchObject
    {
        public BaseService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<TGet> Insert(TInsert request)
        {
            var set = _context.Set<TDb>();

            TDb entity = _mapper.Map<TDb>(request);

            await set.AddAsync(entity);
            await BeforeInsert(entity, request);
            await _context.SaveChangesAsync();

            return _mapper.Map<TGet>(entity);
        }

        public async Task<TGet> Update(int id, TUpdate request)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<TGet>(entity);
        }

        public virtual async Task BeforeInsert(TDb entity, TInsert insert)
        {
        }
    }
}