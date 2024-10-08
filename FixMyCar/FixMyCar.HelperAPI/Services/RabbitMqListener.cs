using FixMyCar.HelperAPI.Interfaces;
using FixMyCar.Model.DTOs.Report;
using FixMyCar.Model.Utilities;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using System.Text.Json;

namespace FixMyCar.HelperAPI.Services
{
    public class RabbitMqListener : BackgroundService
    {
        private readonly IConnection _connection;
        private readonly IModel _channel;
        private readonly IServiceProvider _serviceProvider;

        public RabbitMqListener(IServiceProvider serviceProvider)
        {
            _serviceProvider = serviceProvider;

            var factory = new ConnectionFactory() { HostName = "localhost" };
            _connection = factory.CreateConnection();
            _channel = _connection.CreateModel();

            _channel.QueueDeclare(queue: "generate_report",
                                  durable: false,
                                  exclusive: false,
                                  autoDelete: false,
                                  arguments: null);
        }

        protected override Task ExecuteAsync(CancellationToken stoppingToken)
        {
            var consumer = new EventingBasicConsumer(_channel);

            consumer.Received += async (model, ea) =>
            {
                var body = ea.Body.ToArray();
                var message = Encoding.UTF8.GetString(body);

                var reportRequest = JsonSerializer.Deserialize<ReportRequestDTO>(message);

                using (var scope = _serviceProvider.CreateScope())
                {
                    var generateReportService = scope.ServiceProvider.GetRequiredService<IGenerateReportService>();

                    if (reportRequest!.ShopType == "carpartsshop")
                    {
                        await generateReportService.GenerateReportCarPartsShop(reportRequest);
                    }
                    else if (reportRequest.ShopType == "carrepairshop")
                    {
                        await generateReportService.GenerateReportCarRepairShop(reportRequest);
                    }
                    else
                    {
                        throw new UserException("Not allowed.");
                    }
                }
            };

            _channel.BasicConsume(queue: "generate_report",
                                  autoAck: true,
                                  consumer: consumer);

            return Task.CompletedTask;
        }

        public override void Dispose()
        {
            _channel.Close();
            _connection.Close();
            base.Dispose();
        }
    }
}
