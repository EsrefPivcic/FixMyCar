using FixMyCar.Model.DTOs.Payment;
using Microsoft.AspNetCore.Mvc;
using Stripe;

namespace FixMyCar.API.Controllers
{
    [ApiController]
    public class PaymentsController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaymentsController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost("CreatePaymentIntent")]
        public async Task<IActionResult> CreatePaymentIntent([FromBody] PaymentCreateDTO request)
        {
            var paymentIntentService = new PaymentIntentService();
            var paymentIntent = await paymentIntentService.CreateAsync(new PaymentIntentCreateOptions
            {
                Amount = request.TotalAmount,
                Currency = "eur",
                PaymentMethod = request.PaymentMethodId,
                ConfirmationMethod = "manual",
                Confirm = false
            });

            return Ok(new { clientSecret = paymentIntent.ClientSecret });
        }
    }
}
