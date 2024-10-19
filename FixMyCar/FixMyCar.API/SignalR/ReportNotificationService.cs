using Microsoft.AspNetCore.SignalR;

namespace FixMyCar.API.SignalR
{
    public class ReportNotificationService
    {
        private readonly IHubContext<ReportNotificationHub> _hubContext;

        public ReportNotificationService(IHubContext<ReportNotificationHub> hubContext)
        {
            _hubContext = hubContext;
        }

        public async Task SendServiceNotification(string username, string notificationtype, string message)
        {
            await _hubContext.Clients.User(username).SendAsync("ReportNotification", notificationtype, message);
        }
    }
}
