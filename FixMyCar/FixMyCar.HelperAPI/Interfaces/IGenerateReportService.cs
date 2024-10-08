using FixMyCar.Model.DTOs.Report;

namespace FixMyCar.HelperAPI.Interfaces
{
    public interface IGenerateReportService
    {
        Task GenerateReportCarRepairShop(ReportRequestDTO reportRequest);
        Task GenerateReportCarPartsShop(ReportRequestDTO reportRequest);
    }
}
