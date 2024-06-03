using AutoMapper;
using FixMyCar.Model.DTOs.AuthToken;
using FixMyCar.Model.DTOs.User;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.Utilities;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class AuthService : BaseService<AuthToken, AuthTokenGetDTO, AuthTokentInsertDTO, AuthTokenUpdateDTO, AuthTokenSearchObject>, IAuthService
    {
        private readonly string _secret;
        public AuthService(string secret, FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
            _secret = secret;
        }

        public async Task<string> Login(string username, string password)
        {
            var user = await _context.Users.Include(x => x.Role).FirstOrDefaultAsync(x => x.Username == username);

            if (user == null)
            {
                return null;
            }
            var hash = Hashing.GenerateHash(user.PasswordSalt, password);
            if (hash != user.PasswordHash)
            {
                return null;
            }

            var authToken = new AuthToken();
            authToken = JwtToken.GenerateToken(user, _secret);

            await _context.AuthTokens.AddAsync(authToken);
            await _context.SaveChangesAsync();

            return authToken.Value;
        }

        public async Task RevokeToken(string token)
        {
            AuthToken authToken = await _context.AuthTokens.SingleOrDefaultAsync(t => t.Value == token);
            if (authToken != null)
            {
                authToken.Revoked = DateTime.Now;
                await _context.SaveChangesAsync();
            }
        }

        public async Task<bool> IsTokenRevoked(string token)
        {
            var authToken = await _context.AuthTokens.SingleOrDefaultAsync(t => t.Value == token);
            return authToken?.Revoked != null;
        }

    }
}
