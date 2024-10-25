using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace FixMyCar.API.SignalR
{
    [Authorize]
    public class NotificationHub : Hub
    {
    }
}
