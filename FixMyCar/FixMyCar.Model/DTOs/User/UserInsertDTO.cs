using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.User
{
    public class UserInsertDTO
    {
        public string Username { get; set; }
        public int RoleId { get; set; }
    }
}
