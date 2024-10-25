import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fixmycar_car_parts_shop/src/providers/car_parts_shop_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

List<List<dynamic>>? _monthlyRevenuePerCustomerTypeReportData;
List<List<dynamic>>? _monthlyRevenuePerDayReportData;
List<List<dynamic>>? _monthlyRevenuePerCustomerReportData;
List<List<dynamic>>? _top10MonthlyOrdersReportData;

String? _monthlyRevenuePerCustomerTypeReportDataCsv;
String? _monthlyRevenuePerDayReportDataCsv;
String? _monthlyRevenuePerCustomerReportDataCsv;
String? _top10MonthlyOrdersReportDataCsv;

List<List<dynamic>> _parseCsvReport(String csvData) {
  csvData = csvData.replaceAllMapped(
    RegExp(r'(?<!\r)\n'),
    (match) => '\r\n',
  );

  return CsvToListConverter().convert(csvData);
}

Future<void> _fetchMonthlyRevenuePerCustomerTypeReport(
    BuildContext context) async {
  final report = await Provider.of<CarPartsShopProvider>(context, listen: false)
      .getMonthlyRevenuePerCustomerTypeReport();

  if (report != null) {
    _monthlyRevenuePerCustomerTypeReportData = _parseCsvReport(report);
    _monthlyRevenuePerCustomerTypeReportDataCsv = report;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load report.')),
    );
  }
}

Future<void> _fetchMonthlyRevenuePerDayReport(BuildContext context) async {
  final report = await Provider.of<CarPartsShopProvider>(context, listen: false)
      .getMonthlyRevenuePerDayReport();

  if (report != null) {
    _monthlyRevenuePerDayReportData = _parseCsvReport(report);
    _monthlyRevenuePerDayReportDataCsv = report;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load report.')),
    );
  }
}

Future<void> _fetchMonthlyRevenuePerCustomerReport(BuildContext context) async {
  final report = await Provider.of<CarPartsShopProvider>(context, listen: false)
      .getTop10CustomersMonthlyReport();

  if (report != null) {
    _monthlyRevenuePerCustomerReportData = _parseCsvReport(report);
    _monthlyRevenuePerCustomerReportDataCsv = report;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load report.')),
    );
  }
}

Future<void> _fetchTop10MonthlyOrdersReport(BuildContext context) async {
  final report = await Provider.of<CarPartsShopProvider>(context, listen: false)
      .getTop10OrdersMonthlyReport();

  if (report != null) {
    _top10MonthlyOrdersReportData = _parseCsvReport(report);
    _top10MonthlyOrdersReportDataCsv = report;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load report.')),
    );
  }
}

Future<void> fetchAllStatistics(BuildContext context) async {
  await _fetchMonthlyRevenuePerCustomerTypeReport(context);
  await _fetchMonthlyRevenuePerCustomerReport(context);
  await _fetchMonthlyRevenuePerDayReport(context);
  await _fetchTop10MonthlyOrdersReport(context);
}

int roundedBarMaxY = 0;
int roundedLineMaxY = 0;

List<BarChartGroupData> _createBarChartData() {
  Map<String, double> revenueMap = {"Client": 0.0, "CarRepairShop": 0.0};

  for (int i = 1; i < _monthlyRevenuePerCustomerTypeReportData!.length; i++) {
    var row = _monthlyRevenuePerCustomerTypeReportData![i];
    String reservationType = row[0];
    double revenue = row[1] != 0 ? row[1] : 0.0;

    if (revenueMap.containsKey(reservationType)) {
      revenueMap[reservationType] = revenue;
    }
  }

  double maxY = revenueMap.values.reduce(max);
  roundedBarMaxY = (maxY / 1000).ceil() * 1000;

  return [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
            toY: revenueMap["Client"]!, width: 30, color: Colors.blue)
      ],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
            toY: revenueMap["CarRepairShop"]!, width: 30, color: Colors.green)
      ],
    ),
  ];
}

List<LineChartBarData> _createLineChartData() {
  Map<DateTime, double> totalAmountByDate = {};

  for (int i = 1; i < _monthlyRevenuePerDayReportData!.length; i++) {
    var row = _monthlyRevenuePerDayReportData![i];
    DateTime day = DateTime.parse(row[0]);
    double revenue = row[1];
    totalAmountByDate[day] = revenue;
  }

  double maxY = totalAmountByDate.values.reduce(max);
  roundedLineMaxY = (maxY / 1000).ceil() * 1000;

  return [
    LineChartBarData(
      spots: totalAmountByDate.entries.map((e) {
        return FlSpot(e.key.millisecondsSinceEpoch.toDouble(), e.value);
      }).toList(),
    ),
  ];
}

List<PieChartSectionData> _createPieChartData() {
  List<PieChartSectionData> pieChartSections = [];

  for (int i = 1; i < _monthlyRevenuePerCustomerReportData!.length; i++) {
    var row = _monthlyRevenuePerCustomerReportData![i];
    String customer = row[0];
    double revenue = row[1];

    pieChartSections.add(
      PieChartSectionData(
        titleStyle: const TextStyle(fontSize: 12),
        value: revenue,
        title: customer,
        titlePositionPercentageOffset: 1,
        color: Colors.primaries[customer.hashCode % Colors.primaries.length],
        radius: 230,
      ),
    );
  }

  return pieChartSections;
}

Widget _buildTop10OrdersTable() {
  return DataTable(
    columns: const [
      DataColumn(label: Text('Order Date')),
      DataColumn(label: Text('Customer')),
      DataColumn(label: Text('Customer Type')),
      DataColumn(label: Text('Total Amount')),
      DataColumn(label: Text('Discount')),
    ],
    rows: _top10MonthlyOrdersReportData!.skip(1).map((order) {
      DateTime date = DateTime.parse(order[0]);
      String formattedDate = '${date.day}/${date.month}/${date.year}';
      return DataRow(cells: [
        DataCell(Text(formattedDate)),
        DataCell(Text(order[1].toString())),
        DataCell(Text(order[2].toString())),
        DataCell(Text("${order[3].toStringAsFixed(2)}€")),
        DataCell(Text(order[4].toString())),
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
        interval: roundedLineMaxY / 8,
        getTitlesWidget: (double value, TitleMeta meta) {
          if (value == roundedLineMaxY) return Container();
          return Text(
            '${value.toInt()} €',
            style: const TextStyle(
                fontSize: 10, fontFeatures: [FontFeature.tabularFigures()]),
          );
        },
      ),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: roundedLineMaxY / 8,
        reservedSize: 40,
        getTitlesWidget: (double value, TitleMeta meta) {
          if (value == roundedLineMaxY) return Container();
          return Text(
            '${value.toInt()} €',
            style: const TextStyle(
                fontSize: 10, fontFeatures: [FontFeature.tabularFigures()]),
          );
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
          interval: roundedBarMaxY / 8,
          reservedSize: 40,
          getTitlesWidget: (double value, TitleMeta meta) {
            if (value == roundedBarMaxY) return Container();
            return Text(
              '${value.toInt()} €',
              style: const TextStyle(
                  fontSize: 10, fontFeatures: [FontFeature.tabularFigures()]),
            );
          },
        ),
      ),
      rightTitles: const AxisTitles());
}

Widget _buildPieLegend() {
  return Column(
    children: _monthlyRevenuePerCustomerReportData!.skip(1).map((row) {
      String customerName = row[0];
      double revenue = row[1];
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
          Text('$customerName: ${revenue.toStringAsFixed(2)}€'),
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

BarTouchData _buildBarTouchData() {
  return BarTouchData(touchTooltipData: BarTouchTooltipData(
    getTooltipItem: (group, groupIndex, rod, rodIndex) {
      String title;
      switch (group.x.toInt()) {
        case 0:
          title = 'Clients';
          break;
        case 1:
          title = 'Car Repair Shops';
          break;
        default:
          title = '';
          break;
      }

      String value = rod.toY.toStringAsFixed(2);

      return BarTooltipItem(
        '$title\n$value€',
        const TextStyle(color: Colors.white),
      );
    },
  ));
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

Future<void> _saveMonthlyReportToFile(
    BuildContext context, String? csvReport) async {
  if (csvReport == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No report available to save.')),
    );
    return;
  }

  try {
    String? savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select a location to save your report',
      fileName: 'monthlyreport.csv',
    );

    if (savePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Save operation canceled.')),
      );
      return;
    }

    final file = File(savePath);
    await file.writeAsString(csvReport);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report saved to $savePath')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to save report.')),
    );
  }
}

Future<Widget> buildChart(
    String selectedChartType, BuildContext context) async {
  final GlobalKey _chartKey = GlobalKey();
  await fetchAllStatistics(context);
  switch (selectedChartType) {
    case 'Revenue per customer type':
      if (_monthlyRevenuePerCustomerTypeReportData != null) {
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 950,
                    height: 600,
                    child: BarChart(
                      BarChartData(
                        barGroups: _createBarChartData(),
                        titlesData: _buildBarChartTitles(),
                        barTouchData: _buildBarTouchData(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _exportChartToPDF(_chartKey),
                child: const Text("Export this chart to PDF"),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () => _saveMonthlyReportToFile(
                    context, _monthlyRevenuePerCustomerTypeReportDataCsv),
                child: const Text('Save this diagram data to CSV'),
              ),
            ],
          ),
        ]);
      } else {
        return const Center(child: Text("No report available!"));
      }
    case 'Revenue over time':
      if (_monthlyRevenuePerDayReportData != null) {
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                          width: 950,
                          height: 600,
                          child: LineChart(LineChartData(
                            lineBarsData: _createLineChartData(),
                            titlesData: _buildLineChartTitles(),
                            lineTouchData: _buildLineTouchData(),
                          )))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _exportChartToPDF(_chartKey),
                child: const Text("Export this chart to PDF"),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () => _saveMonthlyReportToFile(
                    context, _monthlyRevenuePerDayReportDataCsv),
                child: const Text('Save this diagram data to CSV'),
              ),
            ],
          ),
        ]);
      } else {
        return const Center(child: Text("No report available!"));
      }
    case 'Revenue per customer':
      if (_monthlyRevenuePerCustomerReportData != null) {
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
                        sections: _createPieChartData(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _exportChartToPDF(_chartKey),
                child: const Text("Export this chart to PDF"),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () => _saveMonthlyReportToFile(
                    context, _monthlyRevenuePerCustomerReportDataCsv),
                child: const Text('Save this diagram data to CSV'),
              ),
            ],
          ),
        ]);
      } else {
        return const Center(child: Text("No report available."));
      }
    case 'Top 10 orders':
      if (_top10MonthlyOrdersReportData != null) {
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 900,
                        child: _buildTop10OrdersTable(),
                      ),
                    ],
                  )),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _exportChartToPDF(_chartKey),
                child: const Text("Export this chart to PDF"),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () => _saveMonthlyReportToFile(
                    context, _top10MonthlyOrdersReportDataCsv),
                child: const Text('Save this diagram data to CSV'),
              ),
            ],
          ),
        ]);
      } else {
        return const Center(child: Text("No report available."));
      }
    default:
      return const Text('Select a chart type');
  }
}
