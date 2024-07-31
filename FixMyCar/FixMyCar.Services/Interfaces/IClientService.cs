using FixMyCar.Model.DTOs.Client;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IClientService : IBaseService<Client, ClientGetDTO, ClientInsertDTO, ClientUpdateDTO, ClientSearchObject>
    {
    }
}
