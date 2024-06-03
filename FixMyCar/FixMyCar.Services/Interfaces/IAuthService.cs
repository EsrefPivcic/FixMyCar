using FixMyCar.Model.DTOs.AuthToken;
using FixMyCar.Model.DTOs.User;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IAuthService : IBaseService<AuthToken, AuthTokenGetDTO, AuthTokentInsertDTO, AuthTokenUpdateDTO, AuthTokenSearchObject>
    {
        Task<string> Login(string username, string passowrd);
        Task RevokeToken(string token);
        Task<bool> IsTokenRevoked(string token);
    }
}
