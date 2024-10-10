import 'package:csv/csv.dart';
import 'package:fixmycar_car_parts_shop/constants.dart';
import 'package:fixmycar_car_parts_shop/src/models/report_filter/report_filter.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_update.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_update_image.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_update_password.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_update_username.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_update_work_details.dart';
import 'package:fixmycar_car_parts_shop/src/providers/auth_provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/car_parts_shop_provider.dart';
import 'package:fixmycar_car_parts_shop/src/screens/login_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/user_provider.dart';
import 'master_screen.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserUpdate? _userUpdate;
  String? _editingField;
  String? _editValue;

  List<int> _selectedWorkDays = [];
  TimeOfDay _openingTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _closingTime = TimeOfDay(hour: 16, minute: 0);
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<CarPartsShopProvider>(context, listen: false).getByToken();
      _fetchReport();
    });
  }

  void _toggleEdit(String field) {
    setState(() {
      _editingField = _editingField == field ? null : field;
    });
  }

  void _updateUser(String field) {
    _userUpdate = UserUpdate(null, null, null, null, null, null, null, null);
    switch (field) {
      case 'name':
        _userUpdate!.name = _editValue;
        break;
      case 'surname':
        _userUpdate!.surname = _editValue;
        break;
      case 'email':
        _userUpdate!.email = _editValue;
        break;
      case 'phone':
        _userUpdate!.phone = _editValue;
        break;
      case 'gender':
        _userUpdate!.gender = _editValue;
        break;
      case 'address':
        _userUpdate!.address = _editValue;
        break;
      case 'postalCode':
        _userUpdate!.postalCode = _editValue;
        break;
      case 'city':
        _userUpdate!.city = _editValue;
        break;
      default:
        break;
    }
  }

  String? _dropdownValue;
  Widget _buildEditableField({
    required String label,
    required String value,
    required String field,
  }) {
    if (field == 'gender') {
      _dropdownValue ??=
          (value == 'Female' || value == 'Male') ? value : 'Custom';

      if (_editValue == null && _dropdownValue == 'Custom') {
        _editValue = value;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4.0),
        if (_editingField == field)
          Row(
            children: [
              if (field == 'gender') ...[
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _dropdownValue,
                    items: ['Female', 'Male', 'Custom'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _dropdownValue = newValue;
                        if (_dropdownValue == 'Custom') {
                          _editValue = value;
                        } else {
                          _editValue = _dropdownValue;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      labelText: AppConstants.genderLabel,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.textFieldRadius),
                      ),
                    ),
                    validator: (_dropdownValue) {
                      if (_dropdownValue == null || _dropdownValue.isEmpty) {
                        return AppConstants.genderError;
                      }
                      return null;
                    },
                  ),
                ),
                if (_dropdownValue == 'Custom') ...[
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      initialValue: '',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onChanged: (newValue) {
                        _editValue = newValue;
                      },
                    ),
                  ),
                ]
              ] else ...[
                Expanded(
                  child: TextFormField(
                    initialValue: value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onChanged: (newValue) {
                      _editValue = newValue;
                    },
                  ),
                ),
              ],
              const SizedBox(width: 8.0),
              TextButton(
                onPressed: () {
                  _toggleEdit(field);
                  setState(() {
                    _editValue = null;
                    _dropdownValue = null;
                  });
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_editValue != null &&
                      _editValue!.isNotEmpty &&
                      (_editValue != value)) {
                    _updateUser(field);
                    await Provider.of<UserProvider>(context, listen: false)
                        .updateByToken(user: _userUpdate!)
                        .then((_) {
                      Provider.of<CarPartsShopProvider>(context, listen: false)
                          .getByToken();
                      setState(() {
                        _editValue = null;
                        _dropdownValue = null;
                      });
                      _toggleEdit(field);
                    });
                  } else {
                    setState(() {
                      _editValue = null;
                      _dropdownValue = null;
                    });
                    _toggleEdit(field);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "This value can't be empty or the same as the old one!"),
                    ));
                  }
                },
                child: const Text('Apply'),
              ),
            ],
          )
        else
          ListTile(
            title: Text(value),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _toggleEdit(field),
            ),
          ),
        const Divider(),
      ],
    );
  }

  UserUpdateImage? _updateImage;

  Future<void> _pickImage() async {
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (pickedFile != null && pickedFile.files.single.path != null) {
      setState(() {
        String selectedImagePath = pickedFile.files.single.path!;
        _updateImage =
            UserUpdateImage(_convertImageToBase64(selectedImagePath)!);
      });
    }
  }

  String? _convertImageToBase64(String? imagePath) {
    if (imagePath == null) return null;
    final bytes = File(imagePath).readAsBytesSync();
    return base64Encode(bytes);
  }

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  void _showChangePasswordForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _oldPasswordController,
                decoration: const InputDecoration(labelText: 'Old Password'),
                obscureText: true,
              ),
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              TextField(
                controller: _confirmNewPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _oldPasswordController.clear();
                _newPasswordController.clear();
                _confirmNewPasswordController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_oldPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Old password is required!'),
                    ),
                  );
                } else if (_newPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('New password is required!'),
                    ),
                  );
                } else if (_confirmNewPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your new password again!'),
                    ),
                  );
                } else {
                  UserUpdatePassword updatePassword = UserUpdatePassword(
                      _oldPasswordController.text,
                      _newPasswordController.text,
                      _confirmNewPasswordController.text);
                  try {
                    await Provider.of<UserProvider>(context, listen: false)
                        .updatePassword(updatePassword: updatePassword)
                        .then((_) {
                      Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                      _oldPasswordController.clear();
                      _newPasswordController.clear();
                      _confirmNewPasswordController.clear();
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Password changed successfully! Please log in again.'),
                        ),
                      );
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  int parseWorkDay(String day) {
    switch (day) {
      case "Sunday":
        return 0;
      case "Monday":
        return 1;
      case "Tuesday":
        return 2;
      case "Wednesday":
        return 3;
      case "Thursday":
        return 4;
      case "Friday":
        return 5;
      case "Saturday":
        return 6;
      default:
        throw ArgumentError("Invalid day of the week");
    }
  }

  List<int> parseWorkDays(List<String> workDays) {
    return workDays.map((day) => parseWorkDay(day)).toList();
  }

  TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  void _showChangeUsernameForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Username'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'New Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Your Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _usernameController.clear();
                _passwordController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_usernameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('New username is required!'),
                    ),
                  );
                } else if (_passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password is required!'),
                    ),
                  );
                } else {
                  UserUpdateUsername updateUsername = UserUpdateUsername(
                      _usernameController.text, _passwordController.text);
                  try {
                    await Provider.of<UserProvider>(context, listen: false)
                        .updateUsername(updateUsername: updateUsername)
                        .then((_) {
                      Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                      _usernameController.clear();
                      _passwordController.clear();
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Username changed successfully! Please log in again.'),
                        ),
                      );
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, VoidCallback onSelect) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label: ${time.format(context)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        ElevatedButton(
          onPressed: onSelect,
          child: const Text('Select Time'),
        ),
      ],
    );
  }

  Future<void> _selectOpeningTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _openingTime,
    );
    if (newTime != null &&
        (newTime.hour < _closingTime.hour ||
            (newTime.hour == _closingTime.hour &&
                newTime.minute < _closingTime.minute))) {
      setState(() {
        _openingTime = newTime;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Please pick a valid opening time! - It must be before the closing time!"),
      ));
    }
  }

  Future<void> _selectClosingTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _closingTime,
    );
    if (newTime != null &&
        (newTime.hour > _openingTime.hour ||
            (newTime.hour == _openingTime.hour &&
                newTime.minute > _openingTime.minute))) {
      setState(() {
        _closingTime = newTime;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Please pick a valid closing time! - It must be after the opening time!"),
      ));
    }
  }

  Widget _buildWorkDaysSelector(List<int> workDays) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: List.generate(7, (index) {
        final day = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][index];
        final dayIndex = index;
        return ChoiceChip(
          label: Text(day),
          selected: workDays.contains(dayIndex),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedWorkDays.add(dayIndex);
              } else {
                _selectedWorkDays.remove(dayIndex);
              }
            });
          },
        );
      }),
    );
  }

  Future<void> _updateWorkDetails() async {
    final updateWorkDetails = UserUpdateWorkDetails(
      _selectedWorkDays,
      'PT${_openingTime.hour}H${_openingTime.minute}M',
      'PT${_closingTime.hour}H${_closingTime.minute}M',
    );

    await Provider.of<CarPartsShopProvider>(context, listen: false)
        .updateWorkDetails(updateWorkDetails: updateWorkDetails)
        .then((_) {
      Provider.of<CarPartsShopProvider>(context, listen: false).getByToken();
    });
    ;
  }

  String? _selectedRole;
  String? _username;
  DateTime? _startDate;
  DateTime? _endDate;
  List<List<dynamic>>? _reportData;

  List<List<dynamic>> _parseCsvReport(String csvData) {
    return CsvToListConverter().convert(csvData);
  }

  Future<void> _fetchReport() async {
    final report =
        await Provider.of<CarPartsShopProvider>(context, listen: false)
            .getReport();

    if (report != null) {
      if (mounted) {
        setState(() {
          _reportData = _parseCsvReport(report);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load report.')),
      );
    }
  }

  Future<void> _openFilterDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Generate Report'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(labelText: "Select Role"),
                    items: const [
                      DropdownMenuItem(value: null, child: Text("All")),
                      DropdownMenuItem(value: "client", child: Text("Client")),
                      DropdownMenuItem(
                          value: "carrepairshop",
                          child: Text("Car Repair Shop")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                        _username = null;
                      });
                    },
                  ),
                  if (_selectedRole != null) ...[
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Username / Repair Shop Name"),
                      onChanged: (value) {
                        setState(() {
                          _username = value;
                        });
                      },
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _startDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: _endDate ?? DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _startDate = picked;
                              });
                            }
                          },
                          child: Text(_startDate != null
                              ? "Start: ${_startDate!.toLocal().toIso8601String().split('T')[0]}"
                              : "Select Start Date"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _endDate ?? DateTime.now(),
                              firstDate: _startDate ?? DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _endDate = picked;
                              });
                            }
                          },
                          child: Text(_endDate != null
                              ? "End: ${_endDate!.toLocal().toIso8601String().split('T')[0]}"
                              : "Select End Date"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _generateReport();
                  },
                  child: Text('Generate'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _generateReport() async {
    final filter = ReportFilter(
      _username,
      _selectedRole,
      _startDate,
      _endDate,
    );
    await Provider.of<CarPartsShopProvider>(context, listen: false)
        .generateReport(filter: filter);
    await _fetchReport();
  }

  String _selectedChartType = 'Revenue per customer type';

  final List<String> _chartTypes = [
    'Revenue per customer type',
    'Revenue over time',
    'Revenue per customer',
    'Top 5 orders'
  ];

  List<BarChartGroupData> _createBarChartData() {
    double clientSum = 0;
    double shopSum = 0;

    final Set<int> uniqueOrderIds = {};

    for (var row in _reportData!.skip(1)) {
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
        barRods: [
          BarChartRodData(toY: clientSum, width: 15, color: Colors.blue)
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(toY: shopSum, width: 15, color: Colors.green)
        ],
      ),
    ];
  }

  List<LineChartBarData> _createLineChartData() {
    Map<DateTime, double> totalAmountByDate = {};

    Map<DateTime, Set<int>> processedOrdersByDate = {};

    List<List<dynamic>> sortedReportData = _reportData!.skip(1).toList()
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

  List<PieChartSectionData> _createPieChartData() {
    Map<String, double> customerTotalAmount = {};

    Map<String, Set<int>> processedOrders = {};

    for (var row in _reportData!.skip(1)) {
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

    return customerTotalAmount.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: entry.key,
        color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
      );
    }).toList();
  }

  Widget _buildTop5OrdersTable() {
    final Map<int, Map<String, dynamic>> groupedOrders = {};

    for (var order in _reportData!.skip(1)) {
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

    final List<Map<String, dynamic>> sortedOrders = groupedOrders.values
        .toList()
      ..sort((a, b) => b['TotalAmount'].compareTo(a['TotalAmount']));

    final top5Orders = sortedOrders.take(5).toList();

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
          DataCell(Text(order['TotalAmount'].toString())),
          DataCell(Text(order['ClientDiscount'].toString())),
        ]);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      child: Consumer<CarPartsShopProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;

          if (user != null && !_isInitialized) {
            _selectedWorkDays = parseWorkDays(user.workDays);
            _openingTime = parseTimeOfDay(user.openingTime);
            _closingTime = parseTimeOfDay(user.closingTime);
            _isInitialized = true;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isWideScreen = constraints.maxWidth > 600;
                return Flex(
                  direction: isWideScreen ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 450,
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (userProvider.isLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else ...[
                                  if (user != null) ...[
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        if (_updateImage != null)
                                          CircleAvatar(
                                            backgroundImage: MemoryImage(
                                                base64Decode(
                                                    _updateImage!.image)),
                                            radius: 50,
                                          )
                                        else if (user.image != null &&
                                            user.image!.isNotEmpty)
                                          CircleAvatar(
                                            backgroundImage: MemoryImage(
                                                base64Decode(user.image!)),
                                            radius: 50,
                                          )
                                        else
                                          const CircleAvatar(
                                            radius: 50,
                                            child: Icon(Icons.person, size: 50),
                                          ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: IconButton(
                                            icon: const Icon(Icons.camera_alt),
                                            onPressed: _pickImage,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_updateImage != null) ...[
                                      const SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _updateImage = null;
                                              });
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (_updateImage?.image != null) {
                                                try {
                                                  await Provider.of<
                                                              UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .updateImage(
                                                          updateImage:
                                                              _updateImage!)
                                                      .then((_) {
                                                    setState(() {
                                                      _updateImage = null;
                                                    });
                                                    Provider.of<CarPartsShopProvider>(
                                                            context,
                                                            listen: false)
                                                        .getByToken();
                                                  });
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content:
                                                            Text(e.toString())),
                                                  );
                                                }
                                              }
                                            },
                                            child: const Text('Save Changes'),
                                          ),
                                        ],
                                      ),
                                    ],
                                    const SizedBox(height: 8.0),
                                    Text.rich(TextSpan(
                                      text: user.username,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    const SizedBox(height: 16.0),
                                    const Text.rich(TextSpan(
                                        text: 'Personal Details',
                                        style: TextStyle(fontSize: 18))),
                                    const SizedBox(height: 8.0),
                                    _buildEditableField(
                                      label: 'Name',
                                      value: user.name,
                                      field: 'name',
                                    ),
                                    _buildEditableField(
                                      label: 'Surname',
                                      value: user.surname,
                                      field: 'surname',
                                    ),
                                    _buildEditableField(
                                      label: 'Gender',
                                      value: user.gender,
                                      field: 'gender',
                                    ),
                                    const SizedBox(height: 16.0),
                                    const Text.rich(TextSpan(
                                        text: 'Company Details',
                                        style: TextStyle(fontSize: 18))),
                                    const SizedBox(height: 8.0),
                                    _buildEditableField(
                                      label: 'Email',
                                      value: user.email,
                                      field: 'email',
                                    ),
                                    _buildEditableField(
                                      label: 'Phone',
                                      value: user.phone,
                                      field: 'phone',
                                    ),
                                    _buildEditableField(
                                      label: 'Address',
                                      value: user.address,
                                      field: 'address',
                                    ),
                                    _buildEditableField(
                                      label: 'Postal Code',
                                      value: user.postalCode,
                                      field: 'postalCode',
                                    ),
                                    _buildEditableField(
                                      label: 'City',
                                      value: user.city,
                                      field: 'city',
                                    ),
                                    const SizedBox(height: 16.0),
                                    const Text.rich(TextSpan(
                                        text: 'Work Details',
                                        style: TextStyle(fontSize: 18))),
                                    const SizedBox(height: 8.0),
                                    const Text.rich(TextSpan(
                                        text: 'Work Days:',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500))),
                                    const SizedBox(height: 8.0),
                                    _buildWorkDaysSelector(_selectedWorkDays),
                                    const SizedBox(height: 8.0),
                                    Text.rich(TextSpan(
                                        text:
                                            'Working time: ${parseTimeOfDay(user.workingHours).hour} hours',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400))),
                                    _buildTimePicker('Opening Time',
                                        _openingTime, _selectOpeningTime),
                                    const SizedBox(height: 8.0),
                                    _buildTimePicker('Closing Time',
                                        _closingTime, _selectClosingTime),
                                    const SizedBox(height: 5.0),
                                    ElevatedButton.icon(
                                      onPressed: _updateWorkDetails,
                                      icon: const Icon(
                                          Icons.work_history_outlined),
                                      label: const Text(
                                          'Apply Work Details Changes'),
                                    ),
                                    const SizedBox(height: 16.0),
                                    const Text.rich(TextSpan(
                                        text: 'Account',
                                        style: TextStyle(fontSize: 18))),
                                    const SizedBox(height: 8.0),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _showChangeUsernameForm();
                                      },
                                      icon: const Icon(Icons.person),
                                      label: const Text(
                                          'Change Username (Company Name)'),
                                    ),
                                    const SizedBox(height: 8.0),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _showChangePasswordForm();
                                      },
                                      icon: const Icon(Icons.lock),
                                      label: const Text('Change Password'),
                                    ),
                                  ] else ...[
                                    const Card(
                                      child: Center(
                                        child: Text(
                                            'Failed loading user information.'),
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0, height: 16.0),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Business Report',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: _fetchReport,
                                      child: const Text('Refresh Report'),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: _openFilterDialog,
                                      child: const Text('Generate Report'),
                                    ),
                                    const SizedBox(width: 10),
                                    DropdownButton<String>(
                                      value: _selectedChartType,
                                      items: _chartTypes.map((String type) {
                                        return DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(type),
                                        );
                                      }).toList(),
                                      onChanged: (String? newChartType) {
                                        setState(() {
                                          _selectedChartType = newChartType!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Expanded(
                                  child: _reportData != null
                                      ? _buildChart()
                                      : const Center(
                                          child: Text("No report available."),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildChart() {
    switch (_selectedChartType) {
      case 'Revenue per customer type':
        return BarChart(
          BarChartData(
            barGroups: _createBarChartData(),
            titlesData: _buildTitles(),
          ),
        );
      case 'Revenue over time':
        return LineChart(
          LineChartData(
            lineBarsData: _createLineChartData(),
            titlesData: _buildTitles(),
          ),
        );
      case 'Revenue per customer':
        return PieChart(
          PieChartData(
            sections: _createPieChartData(),
          ),
        );
      case 'Top 5 orders':
        return _buildTop5OrdersTable();
      default:
        return const Text('Select a chart type');
    }
  }

  FlTitlesData _buildTitles() {
    return const FlTitlesData(
      bottomTitles: AxisTitles(
        axisNameWidget: const Text('Orders'),
        sideTitles: SideTitles(showTitles: true),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }
}
