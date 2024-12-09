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

        public async Task<List<ChatMessage>> GetChatHistory(string senderUser, int recipientUserId)
        {
            var sender = await _context.Users.FirstOrDefaultAsync(u => u.Username == senderUser);

            if (sender != null)
            {
                var chatHistory = await _context.ChatMessages
                .Where(cm => (cm.SenderUserId == sender.Id && cm.RecipientUserId == recipientUserId) ||
                    (cm.SenderUserId == recipientUserId && cm.RecipientUserId == sender.Id))
                .OrderBy(cm => cm.SentAt)
                .ToListAsync();

                return chatHistory;
            }
            else
            {
                throw new UserException("This user doesn't exist");
            }
        }

        public async Task<PagedResult<UserMinimalGetDTO>> GetChats(string username)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);

            if (user != null)
            {
                var participants = await _context.ChatMessages
                .Where(cm => (cm.SenderUserId == user.Id || cm.RecipientUserId == user.Id))
                .Select(cm => cm.SenderUserId == user.Id ? cm.RecipientUserId : cm.SenderUserId)
                .Distinct()
                .ToListAsync();

                var users = await _context.Users
                    .Where(u => participants.Contains(u.Id))
                    .Select(u => new UserMinimalGetDTO
                    {
                        Id = u.Id,
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
            else
            {
                throw new UserException("This user doesn't exist");
            }
        }
    }
}
