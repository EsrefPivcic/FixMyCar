﻿using FixMyCar.Controllers;
using FixMyCar.Model.DTOs.CarPartsShop;
using FixMyCar.Model.DTOs.Report;
using FixMyCar.Model.Entities;
using FixMyCar.Model.SearchObjects;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class CarPartsShopController : BaseController<CarPartsShop, CarPartsShopGetDTO, CarPartsShopInsertDTO, CarPartsShopUpdateDTO, CarPartsShopSearchObject>
    {
        public CarPartsShopController(ICarPartsShopService service, ILogger<BaseController<CarPartsShop, CarPartsShopGetDTO, CarPartsShopInsertDTO, CarPartsShopUpdateDTO, CarPartsShopSearchObject>> logger) : base(service, logger)
        {
        }

        [AllowAnonymous]
        [HttpPost("InsertCarPartsShop")]
        public async Task<CarPartsShopGetDTO> InsertCarPartsShop(CarPartsShopInsertDTO request)
        {
            request.RoleId = 4;
            return await (_service as ICarPartsShopService).Insert(request);
        }

        [HttpPost("GenerateReport")]
        public IActionResult GenerateReport(ReportRequestDTO request)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            request.ShopName = username;
            (_service as ICarPartsShopService).GenerateReport(request);
            return Ok();
        }

        [HttpGet("GetReport")]
        public async Task<IActionResult> GetReport()
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            var report = await (_service as ICarPartsShopService).GetReport(username);
            if (report == null)
            {
                return NotFound();
            }

            return File(report, "text/csv", "report.csv");
        }

        [HttpPut("UpdateWorkDetailsByToken")]
        public async Task UpdateWorkDetails(CarPartsShopWorkDetailsUpdateDTO request)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            request.Username = username;
            await (_service as ICarPartsShopService).UpdateWorkDetails(request);
        }

        [HttpGet("GetByToken")]
        public async Task<PagedResult<CarPartsShopGetDTO>> GetByToken([FromQuery] CarPartsShopSearchObject? search = null)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            search.Username = username;
            return await (_service as ICarPartsShopService).Get(search);
        }
    }
}
