using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class ChatMessage
    {
        public int Id { get; set; }
        public string SenderUserId { get; set; }
        public string RecipientUserId { get; set; }
        public string Message { get; set; }
        public DateTime SentAt { get; set; }
    }
}
