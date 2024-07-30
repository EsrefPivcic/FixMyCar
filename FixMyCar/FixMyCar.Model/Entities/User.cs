using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.Entities
{
    public class User
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public string? Surname { get; set; }
        public string? Email { get; set; }
        public string? Phone { get; set; }
        public string Username { get; set; }
        public DateTime? Created { get; set; }
        public string? Gender { get; set; }
        public string? Address { get; set; }
        public string? PostalCode { get; set; }
        public string? PasswordHash { get; set; }
        public string? PasswordSalt { get; set; }
        public byte[]? Image { get; set; }
        [ForeignKey(nameof(Role))]
        public int RoleId { get; set; }
        public Role Role { get; set; }
        [ForeignKey(nameof(City))]
        public int? CityId { get; set; }
        public City? City { get; set; }
    }
}
