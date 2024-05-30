using FixMyCar.Model.DTOs.Discount;
using FixMyCar.Model.DTOs.Product;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Runtime.CompilerServices;

namespace FixMyCar.Controllers
{
    [ApiController]
    public class DiscountController : BaseController<Discount, DiscountGetDTO, DiscountInsertDTO, DiscountUpdateDTO, DiscountSearchObject>
    {
        public DiscountController(IDiscontService service, ILogger<BaseController<Discount, DiscountGetDTO, DiscountInsertDTO, DiscountUpdateDTO, DiscountSearchObject>> logger) : base(service, logger)
        {
        }
    }
}