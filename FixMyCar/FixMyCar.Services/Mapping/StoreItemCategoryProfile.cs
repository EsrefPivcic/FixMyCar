using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using FixMyCar.Model.DTOs.StoreItemCategory;
using FixMyCar.Model.Entities;

namespace FixMyCar.Services.Mapping
{
    public class StoreItemCategoryProfile : Profile
    {
        public StoreItemCategoryProfile() {
            CreateMap<StoreItemCategory, StoreItemCategoryGetDTO>();
        }
    }
}
