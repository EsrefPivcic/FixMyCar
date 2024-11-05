using FixMyCar.Model.DTOs.User;
using FixMyCar.Model.Entities;
using FixMyCar.Model.Utilities;
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

        public async Task<PagedResult<UserMinimalGetDTO>> GetChats(string username)
        {
            var participants = await _context.ChatMessages
                .Where(cm => (cm.SenderUserId == username || cm.RecipientUserId == username))
                .Select(cm => cm.SenderUserId == username ? cm.RecipientUserId : cm.SenderUserId)
                .Distinct()
                .ToListAsync();

            var users = await _context.Users
                .Where(u => participants.Contains(u.Username))
                .Select(u => new UserMinimalGetDTO
                {
                    Username = u.Username,
                    Name = u.Name,
                    Surname = u.Surname,
                    Image = u.Image != null ? Convert.ToBase64String(u.Image) : ""
                })
                .ToListAsync();

            PagedResult<UserMinimalGetDTO> pagedResult = new PagedResult<UserMinimalGetDTO>();
            pagedResult.Result = users;
            pagedResult.Count = users.Count;
            return pagedResult;
        }
    }
}
