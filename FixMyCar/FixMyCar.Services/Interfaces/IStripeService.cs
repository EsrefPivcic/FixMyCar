using FixMyCar.Model.DTOs.Payment;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMyCar.Services.Interfaces
{
    public interface IStripeService
    {
        Task<PaymentResponseDTO> ConfirmPayment(PaymentCreateDTO request);
        Task<PaymentIntent> CreatePaymentIntent(PaymentCreateDTO request);
    }
}