using FixMyCar.Model.DTOs.Report;
using FixMyCar.Services.Interfaces;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Channels;
using System.Threading.Tasks;

namespace FixMyCar.Services.Services
{
    public class RabbitMQService : IDisposable
    {
        private readonly IConnection _connection;

        public RabbitMQService(IConnectionFactory connectionFactory)
        {
            _connection = connectionFactory.CreateConnection();
        }

        public void SendReportGenerationRequest(ReportRequestDTO reportRequest)
        {
            using var channel = _connection.CreateModel();
            channel.QueueDeclare(queue: "generate_report",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);

            var message = JsonSerializer.Serialize(reportRequest);

            var body = Encoding.UTF8.GetBytes(message);

            channel.BasicPublish(exchange: "",
                                  routingKey: "generate_report",
                                  basicProperties: null,
                                  body: body);
        }

        public void SendMonthlyReportGenerationRequest(MonthlyReportRequestDTO reportRequest)
        {
            using var channel = _connection.CreateModel();
            channel.QueueDeclare(queue: "generate_monthly_report",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);

            var message = JsonSerializer.Serialize(reportRequest);

            var body = Encoding.UTF8.GetBytes(message);

            channel.BasicPublish(exchange: "",
                                  routingKey: "generate_monthly_report",
                                  basicProperties: null,
                                  body: body);
        }

        public void Dispose()
        {
            _connection.Close();
        }
    }
}