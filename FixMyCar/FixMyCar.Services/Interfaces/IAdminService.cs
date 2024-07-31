﻿using FixMyCar.Model.DTOs.Admin;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IAdminService : IBaseService<Admin, AdminGetDTO, AdminInsertDTO, AdminUpdateDTO, AdminSearchObject>
    {
    }
}
