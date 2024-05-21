using FixMyCar.Model.DTOs.Discount;
using FixMyCar.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IDiscontService : IBaseService<Discount, DiscountGetDTO, DiscountInsertDTO, DiscountUpdateDTO, DiscountSearchObject>
    {
    }
}
