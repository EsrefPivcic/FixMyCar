using AutoMapper;
using FixMyCar.Filters;
using FixMyCar.Services.Database;
using FixMyCar.Services.Interfaces;
using FixMyCar.Services.Mapping;
using FixMyCar.Services.Services;
using FixMyCar.Services.StateMachineServices.OrderStateMachine;
using FixMyCar.Services.StateMachineServices.ProductStateMachine;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddTransient<IStoreItemService, StoreItemService>();
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

builder.Services.AddTransient<BaseStoreItemState>();
builder.Services.AddTransient<InitialStoreItemState>();
builder.Services.AddTransient<DraftStoreItemState>();
builder.Services.AddTransient<ActiveStoreItemState>();

builder.Services.AddTransient<BaseOrderState>();
builder.Services.AddTransient<InitialOrderState>();
builder.Services.AddTransient<OnHoldOrderState>();
builder.Services.AddTransient<AcceptedOrderState>();
builder.Services.AddTransient<RejectedOrderState>();
builder.Services.AddTransient<CancelledOrderState>();

builder.Services.AddTransient<SeedService>();

builder.Services.AddAutoMapper(typeof(StoreItemProfile).Assembly);

var key = builder.Configuration.GetValue<string>("JwtSettings:Secret");
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
        }
    };
});

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<FixMyCarContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilter>();
});

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

using (var scope = app.Services.CreateScope())
{
    var seedService = scope.ServiceProvider.GetRequiredService<SeedService>();
    await seedService.SeedData();
}

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
