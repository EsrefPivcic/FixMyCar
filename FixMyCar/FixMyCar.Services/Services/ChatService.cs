using FixMyCar.Model.Entities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class ChatService : IChatService
    {
        protected FixMyCarContext _context;

        public ChatService(FixMyCarContext context)
        {
            _context = context;
        }

        public async Task<List<ChatMessage>> GetChatHistory(string senderUserId, string recipientUserId)
        {
            var chatHistory = await _context.ChatMessages
                .Where(cm => (cm.SenderUserId == senderUserId && cm.RecipientUserId == recipientUserId) ||
                (cm.SenderUserId == recipientUserId && cm.RecipientUserId == senderUserId))
                .OrderBy(cm => cm.SentAt)
                .ToListAsync();

            return chatHistory;
        }
    }
}
