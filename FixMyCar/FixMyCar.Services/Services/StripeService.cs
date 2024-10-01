using FixMyCar.Model.DTOs.Payment;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Interfaces;
using Microsoft.Extensions.Options;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class StripeService : IStripeService
    {
        private readonly StripeSettings _stripeSettings;

        public StripeService(IOptions<StripeSettings> stripeSettings)
        {
            _stripeSettings = stripeSettings.Value;
            StripeConfiguration.ApiKey = _stripeSettings.SecretKey;
        }

        public async Task<PaymentResponseDTO> ConfirmPayment(PaymentCreateDTO request)
        {
            var intentOptions = new PaymentIntentCreateOptions
            {
                Amount = request.TotalAmount,
                Currency = "eur",
                PaymentMethodTypes = new List<string> { "card" },
                Metadata = new Dictionary<string, string>
                {
                    { "order_id", request.OrderId.ToString() },
                },
            };

            var service = new PaymentIntentService();

            var intent = await service.CreateAsync(intentOptions);

            var confirmOptions = new PaymentIntentConfirmOptions
            {
                PaymentMethod = request.PaymentMethodId,
            };

            var response = new PaymentResponseDTO { PaymentIntentId = intent.Id };

            try
            {
                var confirmation = await service.ConfirmAsync(intent.Id, confirmOptions);

                response.Message = confirmation.Status;
            }
            catch (StripeException ex)
            {
                response.Message = ex.StripeError?.Message ?? "An error occurred while processing the payment.";
            }
            catch (UserException ex)
            {
                response.Message = $"An unexpected error occurred: {ex.Message}";
            }

            return response;
        }

        public async Task<IntentResponseDTO> CreatePaymentIntent(PaymentCreateDTO request)
        {
            var options = new PaymentIntentCreateOptions
            {
                Amount = request.TotalAmount,

                Currency = "eur",
                PaymentMethodTypes = new List<string> { "card" },
                Metadata = new Dictionary<string, string>
                {
                    { "order_id", request.OrderId.ToString() }, 
                },
            };

            var service = new PaymentIntentService();
            var paymentintent = await service.CreateAsync(options);

            var response = new IntentResponseDTO { PaymentIntentId = paymentintent.Id, clientSecret = paymentintent.ClientSecret };

            return response;
        }
    }
}
