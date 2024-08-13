using FixMyCar.Model.DTOs.CarRepairShopService;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface ICarRepairShopServiceService : IBaseService<CarRepairShopService, CarRepairShopServiceGetDTO, CarRepairShopServiceInsertDTO, 
        CarRepairShopServiceUpdateDTO, CarRepairShopServiceSearchObject>
    {
        Task<CarRepairShopServiceGetDTO> Activate(int id);
        Task<CarRepairShopServiceGetDTO> Hide(int id);
        Task<List<string>> AllowedActions(int id);
    }
}
