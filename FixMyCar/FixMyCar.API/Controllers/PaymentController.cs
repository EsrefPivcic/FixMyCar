using FixMyCar.Model.DTOs.Payment;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace FixMyCar.API.Controllers
{
    [Authorize]
    [ApiController]
    public class PaymentController : ControllerBase
    {
        private readonly IStripeService _stripeService;

        public PaymentController(IStripeService stripeService)
        {
            _stripeService = stripeService;
        }

        [HttpPost("ConfirmPayment")]
        public async Task<IActionResult> ConfirmPayment([FromBody] PaymentCreateDTO request)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            request.Username = username;
            var confirmation = await _stripeService.ConfirmPayment(request);
            return Ok(confirmation);
        }

        [HttpPost("CreatePaymentIntent")]
        public async Task<IntentResponseDTO> CreatePaymentIntent([FromBody] PaymentCreateDTO request)
        {
            string? username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            request.Username = username;
            var intent = await _stripeService.CreatePaymentIntent(request);
            return await _stripeService.CreatePaymentIntent(request);

        }
    }
}
