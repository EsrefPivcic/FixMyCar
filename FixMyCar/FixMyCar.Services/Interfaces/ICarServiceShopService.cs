using FixMyCar.Model.DTOs.CarServiceShop;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface ICarServiceShopService : IBaseService<CarServiceShop, CarServiceShopGetDTO, CarServiceShopInsertDTO, CarServiceShopUpdateDTO, CarServiceShopSearchObject>
    {
    }
}
