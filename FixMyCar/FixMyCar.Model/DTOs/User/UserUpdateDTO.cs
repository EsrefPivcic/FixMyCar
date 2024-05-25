using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.User
{
    public class UserUpdateDTO
    {
        public string? Username { get; set; }
        public int? RoleId { get; set; }
    }
}
