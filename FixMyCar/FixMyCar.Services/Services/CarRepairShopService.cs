using AutoMapper;
using FixMyCar.Model.DTOs.CarRepairShop;
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
    public class CarRepairShopService : BaseService<CarRepairShop, CarRepairShopGetDTO, CarRepairShopInsertDTO, CarRepairShopUpdateDTO, CarRepairShopSearchObject>, ICarRepairShopService
    {
        public CarRepairShopService(FixMyCarContext context, IMapper mapper) : base (context, mapper) 
        { 
        }
    }
}
