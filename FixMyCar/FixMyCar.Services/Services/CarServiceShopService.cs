using AutoMapper;
using FixMyCar.Model.DTOs.CarServiceShop;
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
    public class CarServiceShopService : BaseService<CarServiceShop, CarServiceShopGetDTO, CarServiceShopInsertDTO, CarServiceShopUpdateDTO, CarServiceShopSearchObject>, ICarServiceShopService
    {
        public CarServiceShopService(FixMyCarContext context, IMapper mapper) : base (context, mapper) 
        { 
        }
    }
}
