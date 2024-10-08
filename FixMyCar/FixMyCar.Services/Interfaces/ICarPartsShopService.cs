﻿using FixMyCar.Model.DTOs.CarPartsShop;
using FixMyCar.Model.DTOs.Report;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface ICarPartsShopService : IBaseService<CarPartsShop, CarPartsShopGetDTO, CarPartsShopInsertDTO, CarPartsShopUpdateDTO, CarPartsShopSearchObject>
    {
        Task UpdateWorkDetails(CarPartsShopWorkDetailsUpdateDTO request);
        void GenerateReport(ReportRequestDTO request);
        Task<byte[]> GetReport(string username);
    }
}
