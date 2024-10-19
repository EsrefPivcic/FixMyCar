using FixMyCar.Model.DTOs.CarPartsShop;
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
        void GenerateMonthlyReports(MonthlyReportRequestDTO request);
        Task<byte[]> GetReport(string username);
        Task<byte[]> GetMonthlyRevenuePerCustomerTypeReport(string username);
        Task<byte[]> GetMonthlyRevenuePerDayReport(string username);
        Task<byte[]> GetTop10CustomersMonthlyReport(string username);
        Task<byte[]> GetTop10OrdersMonthlyReport(string username);
    }
}
