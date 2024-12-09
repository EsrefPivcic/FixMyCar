using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

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

        public async Task SendMessageToUser(int recipientUserId, string message)
        {
            var recipient = await _context.Users.FindAsync(recipientUserId);

            if (recipient != null)
            {
                var senderUsername = Context.UserIdentifier;

                var senderUser = await _context.Users.FirstOrDefaultAsync(u => u.Username == senderUsername);

                var chatMessage = new ChatMessage
                {
                    SenderUserId = senderUser!.Id,
                    RecipientUserId = recipientUserId,
                    Message = message,
                    SentAt = DateTime.UtcNow
                };

                _context.ChatMessages.Add(chatMessage);

                await _context.SaveChangesAsync();

                await Clients.User(recipient.Username).SendAsync("ReceiveMessage", senderUser!.Id, message);
            }
            else 
            {
                throw new UserException("User doesn't exist");
            }
        }
    }
}
