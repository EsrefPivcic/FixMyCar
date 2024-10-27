using FixMyCar.Model.DTOs.CarRepairShop;
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
    public interface ICarRepairShopService : IBaseService<CarRepairShop, CarRepairShopGetDTO, CarRepairShopInsertDTO, CarRepairShopUpdateDTO, CarRepairShopSearchObject>
    {
        Task UpdateWorkDetails(CarRepairShopWorkDetailsUpdateDTO request);
        void GenerateReport(string username, ReportRequestDTO request);
        void GenerateMonthlyReports(string username);
        Task<byte[]> GetReport(string username);
        Task<byte[]> GetMonthlyRevenuePerReservationTypeReport(string username);
        Task<byte[]> GetMonthlyRevenuePerDayReport(string username);
        Task<byte[]> GetTop10CustomersMonthlyReport(string username);
        Task<byte[]> GetTop10ReservationsMonthlyReport(string username);
    }
}
