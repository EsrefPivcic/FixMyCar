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
        public string Name { get; set; }
        public string Surname { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Username { get; set; }
        public string Gender { get; set; }
        public string? Address { get; set; }
        public string? PostalCode { get; set; }
        public string Password { get; set; }
        public string PasswordConfirm { get; set; }
        public string? Image { get; set; }
        public string City { get; set; }
        public int? RoleId { get; set; }
    }
}
