using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IChatService
    {
        Task<List<ChatMessage>> GetChatHistory(string senderUserId, string recipientUserId);
    }
}
