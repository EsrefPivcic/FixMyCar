using AutoMapper;
using FixMyCar.Model.DTOs.User;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using FixMyCar.Services.Utilities;

namespace FixMyCar.Services.Services
{
    public class UserService : BaseService<User, UserGetDTO, UserInsertDTO, UserUpdateDTO, UserSearchObject>, IUserService
    {
        ILogger<UserService> _logger;
        public UserService(FixMyCarContext context, IMapper mapper, ILogger<UserService> logger) : base(context, mapper)
        {
            _logger = logger;
        }

        public override IQueryable<User> AddInclude(IQueryable<User> query, UserSearchObject? search = null)
        {
            query = query.Include("Role");
            return base.AddInclude(query, search);
        }

        public override async Task BeforeInsert(User entity, UserInsertDTO request)
        {
            _logger.LogInformation($"Adding user: {entity.Username}");

            if (request.Password != request.PasswordConfirm)
            {
                throw new Exception("Passwords must match.");
            }

            entity.PasswordSalt = Hashing.GenerateSalt();
            entity.PasswordHash = Hashing.GenerateHash(entity.PasswordSalt, request.Password);
            await base.BeforeInsert(entity, request);
        }
    }
}
