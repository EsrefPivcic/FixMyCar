using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.User
{
    public class UserGetDTO
    {
        public string Username { get; set; }
        public Entities.Role Role { get; set; }
    }
}
