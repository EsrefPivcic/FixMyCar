using AutoMapper;
using FixMyCar.Model.DTOs.Client;
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
    public class ClientService : BaseService<Client, ClientGetDTO, ClientInsertDTO, ClientUpdateDTO, ClientSearchObject>, IClientService
    {
        ILogger<ClientService> _logger;
        public ClientService(FixMyCarContext context, IMapper mapper, ILogger<ClientService> logger) : base(context, mapper)
        {
            _logger = logger;
        }
        public override IQueryable<Client> AddInclude(IQueryable<Client> query, ClientSearchObject? search = null)
        {
            query = query.Include("Role");
            return base.AddInclude(query, search);
        }

        public override async Task BeforeInsert(Client entity, ClientInsertDTO request)
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
