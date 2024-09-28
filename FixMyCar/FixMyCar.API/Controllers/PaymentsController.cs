using FixMyCar.Model.DTOs.Payment;
using FixMyCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

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
            var confirmation = await _stripeService.ConfirmPayment(request);
            return Ok(confirmation);
        }

        [HttpPost("CreatePaymentIntent")]
        public async Task<IActionResult> CreatePaymentIntent([FromBody] PaymentCreateDTO request)
        {
            var intent = await _stripeService.CreatePaymentIntent(request);
            return Ok(new { clientSecret = intent.ClientSecret });
        }
    }
}
