using AutoMapper;
using FixMyCar.Model.DTOs.User;
using FixMyCar.Model.Entities;
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
    public class UserService : BaseService<User, UserGetDTO, UserInsertDTO, UserUpdateDTO, UserSearchObject>, IUserService
    {
        public UserService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<User> AddInclude(IQueryable<User> query, UserSearchObject? search = null)
        {
            query = query.Include("Role");
            return base.AddInclude(query, search);
        }
    }
}
