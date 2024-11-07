using AutoMapper;
using DotNetEnv;
using FixMyCar.API;
using FixMyCar.API.SignalR;
using FixMyCar.Filters;
using FixMyCar.Model.Utilities;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.Mapping;
using FixMyCar.Services.Services;
using FixMyCar.Services.StateMachineServices.CarRepairShopServiceStateMachine;
using FixMyCar.Services.StateMachineServices.OrderStateMachine;
using FixMyCar.Services.StateMachineServices.ReservationStateMachine;
using FixMyCar.Services.StateMachineServices.StoreItemStateMachine;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using RabbitMQ.Client;
using Stripe;
using System.IdentityModel.Tokens.Jwt;
using System.Text;


Env.Load(@"../.env");

var builder = WebApplication.CreateBuilder(args);

var stripeSecretKey = Environment.GetEnvironmentVariable("STRIPE_SECRET_KEY");
var stripePublishableKey = Environment.GetEnvironmentVariable("STRIPE_PUBLISHABLE_KEY");
var jwtSecretFromEnv = Environment.GetEnvironmentVariable("JWT_SECRET_KEY");

builder.Services.AddTransient<IStoreItemService, StoreItemService>();
builder.Services.AddTransient<ICarRepairShopServiceService, CarRepairShopServiceService>();
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<IRoleService, RoleService>();
builder.Services.AddTransient<IOrderService, OrderService>();
builder.Services.AddTransient<IOrderDetailService, OrderDetailService>();
builder.Services.AddTransient<ICarRepairShopService, CarRepairShopService>();
builder.Services.AddTransient<IClientService, ClientService>();
builder.Services.AddTransient<ICarPartsShopService, CarPartsShopService>();
builder.Services.AddTransient<IAdminService, AdminService>();
builder.Services.AddTransient<ICityService, CityService>();
builder.Services.AddTransient<ICarModelService, CarModelService>();
builder.Services.AddTransient<IStoreItemCategoryService, StoreItemCategoryService>();
builder.Services.AddTransient<ICarPartsShopClientDiscountService, CarPartsShopClientDiscountService>();
builder.Services.AddTransient<ICarRepairShopDiscountService, CarRepairShopDiscountService>();
builder.Services.AddTransient<IServiceTypeService, ServiceTypeService>();
builder.Services.AddTransient<IReservationService, ReservationService>();
builder.Services.AddTransient<IReservationDetailService, ReservationDetailService>();
builder.Services.AddTransient<IStripeService, StripeService>();

builder.Services.AddTransient<IRecommenderTrainService, RecommenderTrainService>();
builder.Services.AddTransient<IRecommenderPredictService, RecommenderPredictService>();

builder.Services.AddTransient<BaseStoreItemState>();
builder.Services.AddTransient<InitialStoreItemState>();
builder.Services.AddTransient<DraftStoreItemState>();
builder.Services.AddTransient<ActiveStoreItemState>();

builder.Services.AddTransient<BaseCarRepairShopServiceState>();
builder.Services.AddTransient<InitiralCarRepairShopServiceState>();
builder.Services.AddTransient<DraftCarRepairShopServiceState>();
builder.Services.AddTransient<ActiveCarRepairShopServiceState>();

builder.Services.AddTransient<BaseOrderState>();
builder.Services.AddTransient<InitialOrderState>();
builder.Services.AddTransient<OnHoldOrderState>();
builder.Services.AddTransient<AcceptedOrderState>();
builder.Services.AddTransient<RejectedOrderState>();
builder.Services.AddTransient<CancelledOrderState>();
builder.Services.AddTransient<MissingPaymentOrderState>();
builder.Services.AddTransient<PaymentFailedOrderState>();

builder.Services.AddTransient<BaseReservationState>();
builder.Services.AddTransient<InitialReservationState>();
builder.Services.AddTransient<AwaitingOrderReservationState>();
builder.Services.AddTransient<OrderPendingApprovalReservationState>();
builder.Services.AddTransient<OrderDateConflictReservationState>();
builder.Services.AddTransient<ReadyReservationState>();
builder.Services.AddTransient<AcceptedReservationState>();
builder.Services.AddTransient<RejectedReservationState>();
builder.Services.AddTransient<CancelledReservationState>();
builder.Services.AddTransient<OngoingReservationState>();
builder.Services.AddTransient<CompletedReservationState>();
builder.Services.AddTransient<MissingPaymentReservationState>();
builder.Services.AddTransient<PaymentFailedReservationState>();
builder.Services.AddTransient<OverbookedReservationState>();

builder.Services.AddScoped<NotificationService>();
builder.Services.AddScoped<ReportNotificationService>();
builder.Services.AddTransient<IChatService, ChatService>();

builder.Services.AddSingleton<IConnectionFactory>(sp =>
{
    var hostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? builder.Configuration["RabbitMQ:HostName"];
    var userName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? builder.Configuration["RabbitMQ:UserName"];
    var password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? builder.Configuration["RabbitMQ:Password"];

    return new ConnectionFactory()
    {
        HostName = hostName,
        UserName = userName,
        Password = password,
        RequestedHeartbeat = TimeSpan.FromSeconds(60),
        AutomaticRecoveryEnabled = true
    };
});


builder.Services.AddHostedService<RabbitMqListener>();
builder.Services.AddSingleton<RabbitMQService>();

builder.Services.AddAutoMapper(typeof(StoreItemProfile).Assembly);  


var key = !string.IsNullOrEmpty(jwtSecretFromEnv)
    ? jwtSecretFromEnv
    : builder.Configuration.GetValue<string>("JwtSettings:Secret");
var keyBytes = Encoding.ASCII.GetBytes(key);

builder.Services.AddTransient<IAuthService, AuthService>(provider =>
{
    var context = provider.GetRequiredService<FixMyCarContext>();
    var mapper = provider.GetRequiredService<IMapper>();
    return new AuthService(key, context, mapper);
});

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false;
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(keyBytes),
        ValidateIssuer = false,
        ValidateAudience = false
    };
    options.Events = new JwtBearerEvents
    {
        OnTokenValidated = async context =>
        {
            var authService = context.HttpContext.RequestServices.GetRequiredService<IAuthService>();
            var token = context.SecurityToken as JwtSecurityToken;
            if (await authService.IsTokenRevoked(token.RawData))
            {
                context.Fail("Session expired.");
            }
        },

        OnMessageReceived = context =>
        {
            var accessToken = context.Request.Query["access_token"];

            var path = context.HttpContext.Request.Path;
            if (!string.IsNullOrEmpty(accessToken) &&
            (path.StartsWithSegments("/chathub") || path.StartsWithSegments("/reportNotificationHub") || path.StartsWithSegments("/notificationHub")))
            {
                context.Token = accessToken;
            }

            return Task.CompletedTask;
        }
    };
});

var connectionString = builder.Configuration.GetConnectionString("FixMyCarConnection");
builder.Services.AddDbContext<FixMyCarContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddSignalR();
builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilter>();
});

if (!string.IsNullOrEmpty(stripeSecretKey) && !string.IsNullOrEmpty(stripePublishableKey))
{
    builder.Services.Configure<StripeSettings>(options =>
    {
        options.SecretKey = stripeSecretKey;
        options.PublishableKey = stripePublishableKey;
    });
}
else
{
    builder.Services.Configure<StripeSettings>(builder.Configuration.GetSection("Stripe"));
}

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "JWT Authorization header using the Bearer scheme. Example: \"Authorization: Bearer {token}\"",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] {}
        }
    });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.MapHub<NotificationHub>("/notificationHub");
app.MapHub<ChatHub>("/chatHub");
app.MapHub<ReportNotificationHub>("/reportNotificationHub");

app.Urls.Add("http://0.0.0.0:5148");

var stripeSettings = app.Services.GetRequiredService<IOptions<StripeSettings>>().Value;
StripeConfiguration.ApiKey = stripeSettings.SecretKey;

app.Run();