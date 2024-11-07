using FixMyCar.Model.DTOs.Report;
using RabbitMQ.Client;
using System.Text;
using System.Text.Json;

namespace FixMyCar.HelperAPI.Services
{
    public class RabbitMQService : IDisposable
    {
        private readonly IConnection _connection;

        public RabbitMQService(IConnectionFactory connectionFactory)
        {
            _connection = connectionFactory.CreateConnection();
        }

        public void SendReportNotification(ReportNotificationDTO notification)
        {
            var message = JsonSerializer.Serialize(notification);

            var body = Encoding.UTF8.GetBytes(message);

            using var channel = _connection.CreateModel();
            channel.QueueDeclare(queue: "report_ready",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);

            channel.BasicPublish(exchange: "",
                                  routingKey: "report_ready",
                                  basicProperties: null,
                                  body: body);
        }

        public void Dispose()
        {
            _connection.Close();
        }
    }
}
