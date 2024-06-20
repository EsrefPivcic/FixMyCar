using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;

namespace FixMyCar.Services.Interfaces
{
    public interface IStoreItemService : IBaseService<StoreItem, StoreItemGetDTO, StoreItemInsertDTO, StoreItemUpdateDTO, StoreItemSearchObject>
    {
        Task<StoreItemGetDTO> Activate(int id);
        Task<StoreItemGetDTO> Hide(int id);
        Task<List<string>> AllowedActions(int id);
    }
}