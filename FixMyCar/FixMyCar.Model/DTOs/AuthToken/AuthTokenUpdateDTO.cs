using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Model.DTOs.AuthToken
{
    public class AuthTokenUpdateDTO
    {
        public DateTime Revoked { get; set; }
    }
}
