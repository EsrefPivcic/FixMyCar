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
    public interface IUserService : IBaseService<User, UserGetDTO, UserInsertDTO, UserUpdateDTO, UserSearchObject>
    {
        Task<UserGetDTO> UpdateByToken(UserUpdateDTO request);
        Task UpdatePasswordByToken(UserUpdatePasswordDTO request);
        Task UpdateUsernameByToken(UserUpdateUsernameDTO request);
        Task UpdateImageByToken(UserUpdateImageDTO request);
        Task ChangeActiveStatus(int id);
        Task<UserMinimalGetDTO> Exists(string username, string sender);
    }
}
