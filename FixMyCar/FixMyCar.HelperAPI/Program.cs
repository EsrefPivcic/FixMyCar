using FixMyCar.HelperAPI.Interfaces;
using FixMyCar.HelperAPI.Services;
using FixMyCar.Services.Database;
using Microsoft.EntityFrameworkCore;
using Stripe;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped<IGenerateCarPartsShopReportService, GenerateCarPartsShopReportService>();
builder.Services.AddScoped<IGenerateCarRepairShopReportService, GenerateCarRepairShopReportService>();
builder.Services.AddHostedService<RabbitMqListener>();
builder.Services.AddSingleton<RabbitMQService>();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<FixMyCarContext>(options =>
    options.UseSqlServer(connectionString));

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();