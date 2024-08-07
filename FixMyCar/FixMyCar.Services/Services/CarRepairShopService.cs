﻿using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShop;
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
    public class CarRepairShopService : BaseService<CarRepairShop, CarRepairShopGetDTO, CarRepairShopInsertDTO, CarRepairShopUpdateDTO, CarRepairShopSearchObject>, ICarRepairShopService
    {
        ILogger<CarRepairShopService> _logger;
        public CarRepairShopService(FixMyCarContext context, IMapper mapper, ILogger<CarRepairShopService> logger) : base (context, mapper) 
        {
            _logger = logger;
        }
        public override IQueryable<CarRepairShop> AddInclude(IQueryable<CarRepairShop> query, CarRepairShopSearchObject? search = null)
        {
            query = query.Include("Role");
            return base.AddInclude(query, search);
        }

        public override async Task BeforeInsert(CarRepairShop entity, CarRepairShopInsertDTO request)
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
