using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace FixMyCar.API.SignalR
{
    [Authorize]
    public class ChatHub : Hub
    {
        FixMyCarContext _context;

        public ChatHub(FixMyCarContext context)
        {
            _context = context;
        }   

        public async Task SendMessageToUser(string recipientUserId, string message)
        {
            var senderUserId = Context.UserIdentifier;

            var chatMessage = new ChatMessage
            {
                SenderUserId = senderUserId!,
                RecipientUserId = recipientUserId,
                Message = message,
                SentAt = DateTime.UtcNow
            };

            _context.ChatMessages.Add(chatMessage);

            await _context.SaveChangesAsync();

            await Clients.User(recipientUserId).SendAsync("ReceiveMessage", senderUserId, message);
        }
    }
}
