using FixMyCar.Model.DTOs.Report;
using FixMyCar.Services.Interfaces;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class RabbitMQService : IDisposable
    {
        private readonly IConnection _connection;
        private readonly IModel _channel;

        public RabbitMQService()
        {
            var factory = new ConnectionFactory() { HostName = "localhost" };
            _connection = factory.CreateConnection();
            _channel = _connection.CreateModel();
            _channel.QueueDeclare(queue: "generate_report",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);
            _channel.QueueDeclare(queue: "generate_monthly_report",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);
        }

        public void SendReportGenerationRequest(ReportRequestDTO reportRequest)
        {
            var message = JsonSerializer.Serialize(reportRequest);

            var body = Encoding.UTF8.GetBytes(message);

            _channel.BasicPublish(exchange: "",
                                  routingKey: "generate_report",
                                  basicProperties: null,
                                  body: body);
        }

        public void SendMonthlyReportGenerationRequest(MonthlyReportRequestDTO reportRequest)
        {
            var message = JsonSerializer.Serialize(reportRequest);

            var body = Encoding.UTF8.GetBytes(message);

            _channel.BasicPublish(exchange: "",
                                  routingKey: "generate_monthly_report",
                                  basicProperties: null,
                                  body: body);
        }

        public void Dispose()
        {
            _channel.Close();
            _connection.Close();
        }
    }
}