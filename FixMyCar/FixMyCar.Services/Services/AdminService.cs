using AutoMapper;
using FixMyCar.Model.DTOs.Admin;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
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
            return base.AddInclude(query, search);
        }

        public override async Task BeforeInsert(Admin entity, AdminInsertDTO request)
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
