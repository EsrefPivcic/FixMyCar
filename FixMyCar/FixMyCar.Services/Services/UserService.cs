﻿using AutoMapper;
using FixMyCar.Model.DTOs.User;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using FixMyCar.Services.Utilities;
using FixMyCar.Model.Utilities;
using System.Formats.Asn1;
using Microsoft.AspNetCore.Connections.Features;
using Stripe;

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
            query = query.Include("City");
            return base.AddInclude(query, search);
        }

        public async Task<UserMinimalGetDTO> Exists(string username, string sender)
        {
            if (username == sender)
            {
                throw new UserException("You can't message yourself!");
            }
            else
            {
                var user = await _context.Users.FirstOrDefaultAsync(x => x.Username == username && x.Active);

                if (user != null)
                {
                    return _mapper.Map<UserMinimalGetDTO>(user);
                }
                else
                {
                    throw new UserException("This user doesn't exist!");
                }
            }
        }

        public override IQueryable<User> AddFilter(IQueryable<User> query, UserSearchObject? search = null)
        {
            if (search != null)
            {
                if (search!.Role != null)
                {
                    if (search!.Role != "allexceptadmin")
                    {
                        query = query.Where(u => u.Role.Name == search.Role);
                    }
                    else
                    {
                        query = query.Where(u => u.Role.Name != "admin");
                    }
                }

                if (search!.Username != null)
                {
                    query = query.Where(u => u.Username == search.Username);
                }

                if (search!.ContainsUsername != null)
                {
                    query = query.Where(u => u.Username.Contains(search.ContainsUsername));
                }

                if (search!.Active != null)
                {
                    query = query.Where(u => u.Active == search.Active);
                }
            }

            return base.AddFilter(query, search);
        }

        public async Task ChangeActiveStatus(int id)
        {
            var set = _context.Set<User>();
            var entity = await set.FirstOrDefaultAsync(u => u.Id == id);

            if (entity != null)
            {
                entity.Active = !entity.Active;
                await _context.SaveChangesAsync();

                var tokens = await _context.AuthTokens.Where(t => t.UserId == entity.Id).ToListAsync();

                foreach (var token in tokens)
                {
                    if (token.Revoked == null)
                    {
                        token.Revoked = DateTime.Now;
                        await _context.SaveChangesAsync();
                    }
                }
            }
            else
            {
                throw new UserException("Wrong user id!");
            }
        }

        public async Task UpdateImageByToken(UserUpdateImageDTO request)
        {
            var set = _context.Set<User>();
            var entity = await set.FirstOrDefaultAsync(u => u.Username == request.Username);

            if (entity != null)
            {
                if (request.Image != "")
                {
                    byte[] newImage = Convert.FromBase64String(request.Image);
                    entity.Image = newImage;
                }
                else
                {
                    entity.Image = null;
                }
                await _context.SaveChangesAsync();
            }
            else
            {
                throw new UserException($"User {request.Username} doesn't exist");
            }
        }

        public async Task UpdateUsernameByToken(UserUpdateUsernameDTO request)
        {
            if (request.Username == request.NewUsername)
            {
                throw new UserException("New username can't be the same as the old one.");
            }

            var set = _context.Set<User>();

            var user = await set.FirstOrDefaultAsync(u => u.Username == request.NewUsername);

            if (user != null)
            {
                throw new UserException("This username is already taken.");
            }
            else
            {
                var entity = await set.FirstOrDefaultAsync(u => u.Username == request.Username);

                if (entity != null)
                {
                    string passwordHash = Hashing.GenerateHash(entity.PasswordSalt, request.Password);
                    if (passwordHash != entity.PasswordHash)
                    {
                        throw new UserException("Wrong password.");
                    }
                    else
                    {
                        entity.Username = request.NewUsername!;
                    }
                    await _context.SaveChangesAsync();
                }
                else
                {
                    throw new UserException("User doesn't exist");
                }
            }
        }

        public async Task UpdatePasswordByToken(UserUpdatePasswordDTO request)
        {
            var set = _context.Set<User>();

            var entity = await set.FirstOrDefaultAsync(u => u.Username == request.Username);

            if (entity != null)
            {
                if (request.NewPassword != request.ConfirmNewPassword)
                {
                    throw new UserException("New password values don't match.");
                }
                string newPasswordHashOldSalt = Hashing.GenerateHash(entity.PasswordSalt, request.NewPassword);
                if (newPasswordHashOldSalt == entity.PasswordHash)
                {
                    throw new UserException("New password can't be the same as the old one.");
                }
                string oldPasswordHash = Hashing.GenerateHash(entity.PasswordSalt, request.OldPassword);
                if (oldPasswordHash != entity.PasswordHash)
                {
                    throw new UserException("Wrong old password.");
                }
                else
                {
                    entity.PasswordSalt = Hashing.GenerateSalt();
                    entity.PasswordHash = Hashing.GenerateHash(entity.PasswordSalt, request.NewPassword);
                }

                await _context.SaveChangesAsync();
            }
            else
            {
                throw new UserException("User doesn't exist");
            }
        }

        public async Task<UserGetDTO> UpdateByToken(UserUpdateDTO request)
        {
            var set = _context.Set<User>();

            var entity = await set.FirstOrDefaultAsync(u => u.Username == request.Username);

            if (entity != null)
            {
                _mapper.Map(request, entity);

                if (request.CityId != null)
                {
                    entity.CityId = request.CityId.Value;
                }

                await _context.SaveChangesAsync();

                return _mapper.Map<UserGetDTO>(entity);
            }
            else
            {
                throw new UserException("User doesn't exist");
            }
        }

        public override async Task BeforeInsert(User entity, UserInsertDTO request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(x => x.Username == request.Username);

            if (user == null)
            {
                if (request.Password != request.PasswordConfirm)
                {
                    throw new UserException("Passwords must match.");
                }

                entity.PasswordSalt = Hashing.GenerateSalt();
                entity.PasswordHash = Hashing.GenerateHash(entity.PasswordSalt, request.Password);
                entity.Created = DateTime.Now.Date;

                if (request.Image != null)
                {
                    byte[] newImage = Convert.FromBase64String(request.Image);
                    entity.Image = newImage;
                }
                else
                {
                    entity.Image = null;
                }
                await base.BeforeInsert(entity, request);
            }
            else
            {
                throw new UserException("This username is already in use.");
            }
        }
    }
}
