using FixMyCar.Model.DTOs.Report;

namespace FixMyCar.HelperAPI.Interfaces
{
    public interface IGenerateCarRepairShopReportService
    {
        Task GenerateReport(ReportRequestDTO request);
        Task GenerateMonthlyReports(MonthlyReportRequestDTO request);
    }
}