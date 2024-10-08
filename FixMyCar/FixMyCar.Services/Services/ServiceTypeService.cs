﻿using AutoMapper;
using FixMyCar.Model.DTOs.ServiceType;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class ServiceTypeService : BaseReadOnlyService<ServiceType, ServiceTypeGetDTO, ServiceTypeSearchObject>, IServiceTypeService
    {
        public ServiceTypeService(FixMyCarContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}