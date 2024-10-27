using FixMyCar.Model.DTOs.Report;

namespace FixMyCar.HelperAPI.Interfaces
{
    public interface IGenerateCarPartsShopReportService
    {
        Task GenerateReport(ReportRequestDTO reportRequest);
        Task GenerateMonthlyReports(MonthlyReportRequestDTO reportRequest);
    }
}
