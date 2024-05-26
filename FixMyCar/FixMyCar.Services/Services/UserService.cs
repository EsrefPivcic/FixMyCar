using AutoMapper;
using FixMyCar.Model.DTOs.User;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

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

        public static string GenerateSalt()
        {
            var byteArray = RandomNumberGenerator.GetBytes(16);
            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public override async Task BeforeInsert(User entity, UserInsertDTO request)
        {
            _logger.LogInformation($"Adding user: {entity.Username}");

            if (request.Password != request.PasswordConfirm)
            {
                throw new Exception("Passwords must match.");
            }

            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, request.Password);
            await base.BeforeInsert(entity, request);
        }

        public async Task<UserGetDTO> Login(string username, string password)
        {
            var entity = await _context.Users.Include(x => x.Role).FirstOrDefaultAsync(x => x.Username == username);

            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.PasswordSalt, password);

            if (hash != entity.PasswordHash)
            {
                return null;
            }

            return _mapper.Map<UserGetDTO>(entity);
        }
    }
}
