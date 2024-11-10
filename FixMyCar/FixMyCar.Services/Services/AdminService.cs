using AutoMapper;
using FixMyCar.Model.DTOs.Admin;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.Utilities;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace FixMyCar.Services.Services
{
    public class AdminService : BaseService<Admin, AdminGetDTO, AdminInsertDTO, AdminUpdateDTO, AdminSearchObject>, IAdminService
    {
        ILogger<AdminService> _logger;
        public AdminService(FixMyCarContext context, IMapper mapper, ILogger<AdminService> logger) : base(context, mapper)
        {
            _logger = logger;
        }

        public override IQueryable<Admin> AddInclude(IQueryable<Admin> query, AdminSearchObject? search = null)
        {
            query = query.Include("Role");
            query = query.Include("City");
            return base.AddInclude(query, search);
        }

        public override IQueryable<Admin> AddFilter(IQueryable<Admin> query, AdminSearchObject? search = null)
        {
            if (search != null)
            {
                if (search!.Username != null)
                {
                    query = query.Where(u => u.Username == search.Username);
                }
            }
            return base.AddFilter(query, search);
        }

        public override async Task BeforeInsert(Admin entity, AdminInsertDTO request)
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

                City? city = await _context.Cities.FirstOrDefaultAsync(c => c.Name.ToLower() == request.City.ToLower());

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

                    entity.CityId = newCity.Id;
                }

                if (request.Image != null)
                {
                    byte[] newImage = Convert.FromBase64String(request.Image);
                    entity.Image = newImage;
                }
                else
                {
                    entity.Image = null;
                }

                entity.Active = true;
                await base.BeforeInsert(entity, request);
            }
            else
            {
                throw new UserException("This username is already in use.");
            }
        }
    }
}
