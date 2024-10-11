import 'dart:typed_data';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

List<MapEntry<String, double>> topCustomers = [];

List<BarChartGroupData> _createBarChartData(List<List<dynamic>> reportData) {
  double clientSum = 0;
  double shopSum = 0;

  final Set<int> uniqueOrderIds = {};

  for (var row in reportData.skip(1)) {
    int orderId = row[0];

    if (uniqueOrderIds.contains(orderId)) {
      continue;
    }

    uniqueOrderIds.add(orderId);

    if (row[3] == 'Client') {
      clientSum += row[4] is num ? row[4].toDouble() : 0.0;
    } else if (row[3] == 'Car Repair Shop') {
      shopSum += row[4] is num ? row[4].toDouble() : 0.0;
    }
  }

  return [
    BarChartGroupData(
      x: 0,
      barRods: [BarChartRodData(toY: clientSum, width: 15, color: Colors.blue)],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [BarChartRodData(toY: shopSum, width: 15, color: Colors.green)],
    ),
  ];
}

List<LineChartBarData> _createLineChartData(List<List<dynamic>> reportData) {
  Map<DateTime, double> totalAmountByDate = {};

  Map<DateTime, Set<int>> processedOrdersByDate = {};

  List<List<dynamic>> sortedReportData = reportData.skip(1).toList()
    ..sort((a, b) => DateTime.parse(a[1]).compareTo(DateTime.parse(b[1])));

  for (var row in sortedReportData) {
    DateTime orderDate = DateTime.parse(row[1]);
    int orderId = row[0];
    double totalAmount = row[4] is num ? row[4].toDouble() : 0.0;

    processedOrdersByDate.putIfAbsent(orderDate, () => <int>{});

    if (!processedOrdersByDate[orderDate]!.contains(orderId)) {
      processedOrdersByDate[orderDate]!.add(orderId);

      if (totalAmountByDate.containsKey(orderDate)) {
        totalAmountByDate[orderDate] =
            totalAmountByDate[orderDate]! + totalAmount;
      } else {
        totalAmountByDate[orderDate] = totalAmount;
      }
    }
  }

  return [
    LineChartBarData(
      spots: totalAmountByDate.entries.map((e) {
        return FlSpot(e.key.millisecondsSinceEpoch.toDouble(), e.value);
      }).toList(),
    ),
  ];
}

List<PieChartSectionData> _createPieChartData(List<List<dynamic>> reportData) {
  Map<String, double> customerTotalAmount = {};

  Map<String, Set<int>> processedOrders = {};

  for (var row in reportData.skip(1)) {
    String customer = row[2];
    int orderId = row[0];
    double totalAmount = row[4] is num ? row[4].toDouble() : 0.0;

    processedOrders.putIfAbsent(customer, () => <int>{});

    if (!processedOrders[customer]!.contains(orderId)) {
      processedOrders[customer]!.add(orderId);

      if (customerTotalAmount.containsKey(customer)) {
        customerTotalAmount[customer] =
            customerTotalAmount[customer]! + totalAmount;
      } else {
        customerTotalAmount[customer] = totalAmount;
      }
    }
  }

  topCustomers = customerTotalAmount.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  topCustomers = topCustomers.take(10).toList();

  return topCustomers.map((entry) {
    return PieChartSectionData(
      titleStyle: const TextStyle(fontSize: 12),
      value: entry.value,
      title: entry.key,
      titlePositionPercentageOffset: 1,
      color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
      radius: 230,
    );
  }).toList();
}

Widget _buildTop10OrdersTable(List<List<dynamic>> reportData) {
  final Map<int, Map<String, dynamic>> groupedOrders = {};

  for (var order in reportData.skip(1)) {
    int orderId = order[0];
    if (!groupedOrders.containsKey(orderId)) {
      groupedOrders[orderId] = {
        'OrderDate': order[1],
        'Customer': order[2],
        'CustomerType': order[3],
        'TotalAmount': order[4],
        'ClientDiscount': order[6],
      };
    } else {
      groupedOrders[orderId]!['TotalAmount'] = order[4];
    }
  }

  final List<Map<String, dynamic>> sortedOrders = groupedOrders.values.toList()
    ..sort((a, b) => b['TotalAmount'].compareTo(a['TotalAmount']));

  final top5Orders = sortedOrders.take(10).toList();

  return DataTable(
    columns: const [
      DataColumn(label: Text('Order Date')),
      DataColumn(label: Text('Customer')),
      DataColumn(label: Text('Customer Type')),
      DataColumn(label: Text('Total Amount')),
      DataColumn(label: Text('Client Discount')),
    ],
    rows: top5Orders.map((order) {
      return DataRow(cells: [
        DataCell(Text(order['OrderDate'].toString())),
        DataCell(Text(order['Customer'].toString())),
        DataCell(Text(order['CustomerType'].toString())),
        DataCell(Text("${order['TotalAmount']}€")),
        DataCell(Text(order['ClientDiscount'].toString())),
      ]);
    }).toList(),
  );
}

FlTitlesData _buildLineChartTitles() {
  return FlTitlesData(
    bottomTitles: const AxisTitles(
      sideTitles: SideTitles(
        showTitles: false,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (double value, TitleMeta meta) {
          return Text('${value.toInt()}€');
        },
      ),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (double value, TitleMeta meta) {
          return Text('${value.toInt()}€');
        },
      ),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );
}

LineTouchData _buildLineTouchData() {
  return LineTouchData(
    enabled: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipItems: (List<LineBarSpot> touchedSpots) {
        return touchedSpots.map((spot) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
          String formattedDate = '${date.day}/${date.month}/${date.year}';
          return LineTooltipItem(
            'Date: $formattedDate\nRevenue: ${spot.y.toStringAsFixed(2)}€',
            const TextStyle(color: Colors.white),
          );
        }).toList();
      },
    ),
  );
}

FlTitlesData _buildBarChartTitles() {
  return FlTitlesData(
      topTitles: const AxisTitles(),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            switch (value.toInt()) {
              case 0:
                return const Text('Clients');
              case 1:
                return const Text('Car Repair Shops');
              default:
                return const Text('');
            }
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('${value.toInt()}€');
          },
        ),
      ),
      rightTitles: const AxisTitles());
}

Widget _buildPieLegend() {
  return Column(
    children: topCustomers.map((entry) {
      String customerName = entry.key;
      String revenue = '${entry.value.toStringAsFixed(2)}€';
      Color sectionColor =
          Colors.primaries[customerName.hashCode % Colors.primaries.length];

      return Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: sectionColor,
          ),
          const SizedBox(width: 8),
          Text('$customerName: $revenue'),
        ],
      );
    }).toList(),
  );
}

Widget _buildBarLegend() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        children: [
          Icon(Icons.circle, color: Colors.blue, size: 10),
          SizedBox(width: 5),
          Text('Clients'),
        ],
      ),
      SizedBox(width: 20),
      Row(
        children: [
          Icon(Icons.circle, color: Colors.green, size: 10),
          SizedBox(width: 5),
          Text('Car Repair Shops'),
        ],
      ),
    ],
  );
}

Future<Uint8List> _captureChartToImage(GlobalKey key) async {
  RenderRepaintBoundary boundary =
      key.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

Future<void> _exportChartToPDF(GlobalKey chartKey) async {
  final imageBytes = await _captureChartToImage(chartKey);

  final pdf = pw.Document();
  pdf.addPage(pw.Page(
    build: (pw.Context context) => pw.Center(
      child: pw.Image(pw.MemoryImage(imageBytes)),
    ),
  ));

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

Widget buildChart(List<List<dynamic>> reportData, String selectedChartType) {
  final GlobalKey _chartKey = GlobalKey();

  switch (selectedChartType) {
    case 'Revenue per customer type':
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        RepaintBoundary(
          key: _chartKey,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Revenue per customer type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 950,
                  height: 600,
                  child: BarChart(
                    BarChartData(
                      barGroups: _createBarChartData(reportData),
                      titlesData: _buildBarChartTitles(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildBarLegend(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _exportChartToPDF(_chartKey),
          child: const Text("Export this chart to PDF"),
        ),
      ]);
    case 'Revenue over time':
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        RepaintBoundary(
          key: _chartKey,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Revenue over time',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                        width: 950,
                        height: 600,
                        child: LineChart(LineChartData(
                          lineBarsData: _createLineChartData(reportData),
                          titlesData: _buildLineChartTitles(),
                          lineTouchData: _buildLineTouchData(),
                        )))),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _exportChartToPDF(_chartKey),
          child: const Text("Export this chart to PDF"),
        ),
      ]);
    case 'Revenue per customer':
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        RepaintBoundary(
          key: _chartKey,
          child: Card(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Revenue per customer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 950,
                  height: 600,
                  child: PieChart(
                    PieChartData(
                      sections: _createPieChartData(reportData),
                      centerSpaceRadius: 0,
                    ),
                  ),
                ),
                _buildPieLegend(),
              ],
            ),
          )),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _exportChartToPDF(_chartKey),
          child: const Text("Export this chart to PDF"),
        ),
      ]);
    case 'Top 10 orders':
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        RepaintBoundary(
          key: _chartKey,
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Top 10 orders',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 900,
                      child: _buildTop10OrdersTable(reportData),
                    ),
                  ],
                )),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _exportChartToPDF(_chartKey),
          child: const Text("Export this table to PDF"),
        ),
      ]);
    default:
      return const Text('Select a chart type');
  }
}
