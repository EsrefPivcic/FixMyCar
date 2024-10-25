import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_repair_shop_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

List<List<dynamic>>? _monthlyRevenuePerReservationTypeReportData;
List<List<dynamic>>? _monthlyRevenuePerDayReportData;
List<List<dynamic>>? _monthlyRevenuePerCustomerReportData;
List<List<dynamic>>? _top10MonthlyReservationsReportData;

String? _monthlyRevenuePerReservationTypeReportDataCsv;
String? _monthlyRevenuePerDayReportDataCsv;
String? _monthlyRevenuePerCustomerReportDataCsv;
String? _top10MonthlyReservationsReportDataCsv;

List<List<dynamic>> _parseCsvReport(String csvData) {
  csvData = csvData.replaceAllMapped(
    RegExp(r'(?<!\r)\n'),
    (match) => '\r\n',
  );

  return CsvToListConverter().convert(csvData);
}

Future<void> _fetchMonthlyRevenuePerReservationTypeReport(
    BuildContext context) async {
  final report =
      await Provider.of<CarRepairShopProvider>(context, listen: false)
          .getMonthlyRevenuePerReservationTypeReport();

  if (report != null) {
    _monthlyRevenuePerReservationTypeReportData = _parseCsvReport(report);
    _monthlyRevenuePerReservationTypeReportDataCsv = report;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load report.')),
    );
  }
}

Future<void> _fetchMonthlyRevenuePerDayReport(BuildContext context) async {
  final report =
      await Provider.of<CarRepairShopProvider>(context, listen: false)
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
  final report =
      await Provider.of<CarRepairShopProvider>(context, listen: false)
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

Future<void> _fetchTop10MonthlyReservationsReport(BuildContext context) async {
  final report =
      await Provider.of<CarRepairShopProvider>(context, listen: false)
          .getTop10ReservationsMonthlyReport();

  if (report != null) {
    _top10MonthlyReservationsReportData = _parseCsvReport(report);
    _top10MonthlyReservationsReportDataCsv = report;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load report.')),
    );
  }
}

Future<void> fetchAllStatistics(BuildContext context) async {
  await _fetchMonthlyRevenuePerReservationTypeReport(context);
  await _fetchMonthlyRevenuePerCustomerReport(context);
  await _fetchMonthlyRevenuePerDayReport(context);
  await _fetchTop10MonthlyReservationsReport(context);
}

int roundedBarMaxY = 0;
int roundedLineMaxY = 0;

List<BarChartGroupData> _createBarChartData() {
  Map<String, double> revenueMap = {
    "Diagnostics": 0.0,
    "Repairs": 0.0,
    "Repairs and Diagnostics": 0.0,
  };

  for (int i = 1;
      i < _monthlyRevenuePerReservationTypeReportData!.length;
      i++) {
    var row = _monthlyRevenuePerReservationTypeReportData![i];
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
            toY: revenueMap["Diagnostics"]!, width: 30, color: Colors.yellow)
      ],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
            toY: revenueMap["Repairs"]!, width: 30, color: Colors.green)
      ],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
            toY: revenueMap["Repairs and Diagnostics"]!,
            width: 30,
            color: Colors.blue)
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

Widget _buildTop10ReservationsTable() {
  return DataTable(
    columns: const [
      DataColumn(label: Text('Reservation Created')),
      DataColumn(label: Text('Reservation Date')),
      DataColumn(label: Text('Customer')),
      DataColumn(label: Text('Total Amount')),
      DataColumn(label: Text('Type')),
      DataColumn(label: Text('Discount')),
    ],
    rows: _top10MonthlyReservationsReportData!.skip(1).map((reservation) {
      DateTime dateCreated = DateTime.parse(reservation[0]);
      String formattedDateCreated =
          '${dateCreated.day}/${dateCreated.month}/${dateCreated.year}';
      DateTime date = DateTime.parse(reservation[1]);
      String formattedDate = '${date.day}/${date.month}/${date.year}';
      return DataRow(cells: [
        DataCell(Text(formattedDateCreated)),
        DataCell(Text(formattedDate)),
        DataCell(Text(reservation[2].toString())),
        DataCell(Text("${reservation[3].toStringAsFixed(2)}€")),
        DataCell(Text(reservation[4].toString())),
        DataCell(Text(reservation[5].toString())),
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
                return const Text('Diagnostics');
              case 1:
                return const Text('Repairs');
              case 2:
                return const Text('Repairs and Diagnostics');
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

BarTouchData _buildBarTouchData() {
  return BarTouchData(touchTooltipData: BarTouchTooltipData(
    getTooltipItem: (group, groupIndex, rod, rodIndex) {
      String title;
      switch (group.x.toInt()) {
        case 0:
          title = 'Diagnostics';
          break;
        case 1:
          title = 'Repairs';
          break;
        case 2:
          title = 'Repairs and Diagnostics';
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
          Icon(Icons.circle, color: Colors.yellow, size: 10),
          SizedBox(width: 5),
          Text('Diagnostics'),
        ],
      ),
      SizedBox(width: 20),
      Row(
        children: [
          Icon(Icons.circle, color: Colors.green, size: 10),
          SizedBox(width: 5),
          Text('Repairs'),
        ],
      ),
      SizedBox(width: 20),
      Row(
        children: [
          Icon(Icons.circle, color: Colors.blue, size: 10),
          SizedBox(width: 5),
          Text('Repairs and Diagnostics'),
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
    case 'Revenue per reservation type':
      if (_monthlyRevenuePerReservationTypeReportData != null) {
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
                      'Revenue per reservation type',
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
                    context, _monthlyRevenuePerReservationTypeReportDataCsv),
                child: const Text('Save this diagram data to CSV'),
              ),
            ],
          ),
        ]);
      } else {
        return const Center(child: Text("No report available!"));
      }
    case 'Daily revenue':
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
                      'Daily revenue',
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
    case 'Top 10 customers':
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
                    'Top 10 customers',
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
    case 'Top 10 reservations':
      if (_top10MonthlyReservationsReportData != null) {
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
                        'Top 10 reservations',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 1100,
                        child: _buildTop10ReservationsTable(),
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
                    context, _top10MonthlyReservationsReportDataCsv),
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
