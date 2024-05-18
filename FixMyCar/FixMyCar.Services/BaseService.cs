using AutoMapper;
using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services
{
    public class BaseService<T, TDb> : IBaseService<T> where TDb : class where T : class
    {
        FixMyCarContext _context;
        IMapper _mapper;
        public BaseService(FixMyCarContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<List<T>> Get()
        {
            var query = _context.Set<TDb>().AsQueryable();

            var list = await query.ToListAsync();

            return _mapper.Map<List<T>>(list);
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