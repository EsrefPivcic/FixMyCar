using AutoMapper;
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

namespace FixMyCar.Services.Services
{
    public class UserService : BaseService<User, UserGetDTO, UserInsertDTO, UserUpdateDTO, UserSearchObject>, IUserService
    {
        ILogger<UserService> _logger;
        public UserService(FixMyCarContext context, IMapper mapper, ILogger<UserService> logger) : base(context, mapper)
        {
            _logger = logger;
        }

        public async Task UpdateImageByToken(UserUpdateImageDTO request)
        {
            var set = _context.Set<User>();
            var entity = await set.FirstOrDefaultAsync(u => u.Username == request.Username);

            if (entity != null)
            {
                byte[] newImage = Convert.FromBase64String(request.Image);
                entity.Image = ImageHelper.Resize(newImage, 100);
                await _context.SaveChangesAsync();
            }
            else
            {
                throw new UserException("User doesn't exist");
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

                if (!string.IsNullOrEmpty(request.City))
                {
                    City city = await _context.Cities.FirstOrDefaultAsync(c => c.Name.ToLower() == request.City.ToLower());

                    if (city != null)
                    {
                        entity.CityId = city.Id;
                    }
                    else
                    {
                        var citySet = _context.Set<City>();
                        City newCity = new City
                        {
                            Name = request.City
                        };
                        await citySet.AddAsync(newCity);
                        await _context.SaveChangesAsync();

                        newCity = await _context.Cities.FirstOrDefaultAsync(c => c.Name.ToLower() == request.City.ToLower());
                        entity.CityId = newCity.Id;
                    }
                }
                await _context.SaveChangesAsync();

                return _mapper.Map<UserGetDTO>(entity);
            }
            else
            {
                throw new UserException("User doesn't exist");
            }
        }

        public override IQueryable<User> AddInclude(IQueryable<User> query, UserSearchObject? search = null)
        {
            query = query.Include("Role");
            query = query.Include("City");
            return base.AddInclude(query, search);
        }

        public override IQueryable<User> AddFilter(IQueryable<User> query, UserSearchObject? search = null)
        {
            if (search != null)
            {
                if (search?.Username != null)
                {
                    query = query.Where(u => u.Username ==  search.Username);
                }
            }

            return base.AddFilter(query, search);   
        }

        public override async Task BeforeInsert(User entity, UserInsertDTO request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(x => x.Username == request.Username);

            if (user == null)
            {
                _logger.LogInformation($"Adding user: {entity.Username}");

                if (request.Password != request.PasswordConfirm)
                {
                    throw new UserException("Passwords must match.");
                }

                entity.PasswordSalt = Hashing.GenerateSalt();
                entity.PasswordHash = Hashing.GenerateHash(entity.PasswordSalt, request.Password);
                entity.Created = DateTime.Now.Date;

                using var transaction = await _context.Database.BeginTransactionAsync();
                City city = await _context.Cities.FirstOrDefaultAsync(c => c.Name.ToLower() == request.City.ToLower());

                if (city != null)
                {
                    entity.CityId = city.Id;
                }
                else
                {
                    var citySet = _context.Set<City>();
                    City newCity = new City
                    {
                        Name = request.City
                    };
                    await citySet.AddAsync(newCity);
                    await _context.SaveChangesAsync();

                    newCity = await _context.Cities.FirstOrDefaultAsync(c => c.Name.ToLower() == request.City.ToLower());
                    entity.CityId = newCity.Id;
                }

                await _context.SaveChangesAsync();

                await transaction.CommitAsync();

                await base.BeforeInsert(entity, request);
            }
            else
            {
                throw new UserException("This username is already in use.");
            }
        }
    }
}
