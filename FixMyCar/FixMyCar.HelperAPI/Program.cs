using FixMyCar.HelperAPI.Interfaces;
using FixMyCar.HelperAPI.Services;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using RabbitMQ.Client;
using Stripe;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped<IGenerateCarPartsShopReportService, GenerateCarPartsShopReportService>();
builder.Services.AddScoped<IGenerateCarRepairShopReportService, GenerateCarRepairShopReportService>();

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

var connectionString = builder.Configuration.GetConnectionString("FixMyCarConnection");
builder.Services.AddDbContext<FixMyCarContext>(options =>
    options.UseSqlServer(connectionString));

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();

app.MapControllers();

app.Run();