using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.User
{
    public class UserGetDTO
    {
        public string Name { get; set; }
        public string Surname { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Username { get; set; }
        public DateTime Created { get; set; }
        public string Gender { get; set; }
        public string Address { get; set; }
        public string PostalCode { get; set; }
        public string? Image { get; set; }
        public string? Role { get; set; }
        public string? City { get; set; }
    }
}
