using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.Report
{
    public class ReportNotificationDTO
    {
        public string Username { get; set; }
        public string NotificationType { get; set; }
        public string Message { get; set; }
    }
}
