using FixMyCar.Model.Entities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace FixMyCar.API.Controllers
{
    [Authorize]
    [ApiController]
    public class ChatHistoryController : ControllerBase
    {
        private readonly IChatService _chatService;

        public ChatHistoryController(IChatService chatService)
        {
            _chatService = chatService;
        }

        [HttpGet("GetChatHistory/{recipientUserId}")]
        public async Task<List<ChatMessage>> GetChatHistory(string recipientUserId)
        {
            var senderUserId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            return await _chatService.GetChatHistory(senderUserId!, recipientUserId);
        }
    }
}
