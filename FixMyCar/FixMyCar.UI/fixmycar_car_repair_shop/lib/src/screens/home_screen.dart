import 'package:csv/csv.dart';
import 'package:fixmycar_car_repair_shop/constants.dart';
import 'package:fixmycar_car_repair_shop/src/models/city/city.dart';
import 'package:fixmycar_car_repair_shop/src/models/report_filter/report_filter.dart';
import 'package:fixmycar_car_repair_shop/src/models/user/user_update.dart';
import 'package:fixmycar_car_repair_shop/src/models/user/user_update_image.dart';
import 'package:fixmycar_car_repair_shop/src/models/user/user_update_password.dart';
import 'package:fixmycar_car_repair_shop/src/models/user/user_update_username.dart';
import 'package:fixmycar_car_repair_shop/src/models/user/user_update_work_details.dart';
import 'package:fixmycar_car_repair_shop/src/providers/auth_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_repair_shop_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/city_provider.dart';
import 'package:fixmycar_car_repair_shop/src/screens/login_screen.dart';
import 'package:fixmycar_car_repair_shop/src/services/report_notification_service.dart';
import 'package:fixmycar_car_repair_shop/src/utilities/phone_number_formatter.dart';
import 'package:fixmycar_car_repair_shop/src/widgets/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/user_provider.dart';
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
  late Future<Widget> _chartFuture;

  List<int> _selectedWorkDays = [];
  TimeOfDay _openingTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _closingTime = TimeOfDay(hour: 16, minute: 0);
  int? _employees;
  bool _isInitialized = false;
  final ReportNotificationService _notificationService =
      ReportNotificationService();
  String _selectedChartType = 'Revenue per reservation type';

  List<City>? _cities;
  int? _selectedCity;

  @override
  void initState() {
    super.initState();
    _chartFuture = buildChart(_selectedChartType, context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<CarRepairShopProvider>(context, listen: false).getByToken();
      if (mounted) {
        _fetchReport();
        _initializeNotifications(context);
        await _fetchCities();
      }
    });
  }

  Future _fetchCities() async {
    if (mounted) {
      var cityProvider = Provider.of<CityProvider>(context, listen: false);
      await cityProvider.getCities().then((_) {
        _cities = cityProvider.cities;
      });
    }
  }

  void _toggleEdit(String field) {
    setState(() {
      _editingField = _editingField == field ? null : field;
    });
  }

  void _initializeNotifications(BuildContext context) async {
    final FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');

    _notificationService.onNotificationReceived =
        (String notificationType, String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 5),
        ),
      );
      if (notificationType == "customreport") {
        _fetchReport();
      } else if (notificationType == "monthlystatistics") {
        setState(() {
          _chartFuture = buildChart(_selectedChartType, context);
        });
      }
    };
    if (mounted) {
      await _notificationService.initConnection(token!);
    }
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
        _userUpdate!.cityId = _selectedCity;
        break;
      default:
        break;
    }
  }

  Widget _buildTextField(String currentValue, String errorText,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return TextFormField(
      initialValue: currentValue,
      onChanged: (newValue) {
        _editValue = newValue;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textFieldRadius),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: [
        LengthLimitingTextInputFormatter(25),
      ],
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        if (value == currentValue) {
          return "New value can't be the same";
        }
        if (num.tryParse(value) is num) {
          return "This value can't be numeric";
        }
        if (value.length > 25) {
          return "This value can't be longer than 25 characters";
        }
        return null;
      },
    );
  }

  Widget _buildPostalCodeTextField(String currentValue, String errorText,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return TextFormField(
      initialValue: currentValue,
      onChanged: (newValue) {
        _editValue = newValue;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textFieldRadius),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: [
        LengthLimitingTextInputFormatter(25),
      ],
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        if (value == currentValue) {
          return "New postal code can't be the same";
        }
        if (value.length > 25) {
          return "This value can't be longer than 25 characters";
        }
        return null;
      },
    );
  }

  Widget _buildEmailField(String currentValue, String errorText) {
    return TextFormField(
      initialValue: currentValue,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textFieldRadius),
        ),
      ),
      onChanged: (newValue) {
        _editValue = newValue;
      },
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        LengthLimitingTextInputFormatter(40),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        if (value == currentValue) {
          return "New email can't be the same";
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return "Please enter a valid email address";
        }
        return null;
      },
    );
  }

  Widget _buildPhoneNumberField(String currentValue, String errorText) {
    String noPrefix = currentValue.trim().replaceFirst('+387 ', '');
    return TextFormField(
      initialValue: noPrefix,
      decoration: InputDecoration(
        prefixText: '+387 ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textFieldRadius),
        ),
      ),
      onChanged: (newValue) {
        _editValue = "+387 $newValue";
      },
      keyboardType: TextInputType.phone,
      inputFormatters: [
        PhoneNumberFormatter(),
        LengthLimitingTextInputFormatter(12),
      ],
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return errorText;
        }
        if (value == noPrefix) {
          return "New phone number can't be the same";
        }
        if (!RegExp(r'^\d{8,9}$').hasMatch(value.replaceAll(' ', ''))) {
          return "Phone number must be 8 or 9 digits";
        }
        return null;
      },
    );
  }

  Widget _customTextFormField(
      {required String field,
      required String currentValue,
      required String error}) {
    switch (field) {
      case 'name':
        return _buildTextField(currentValue, error);
      case 'surname':
        return _buildTextField(currentValue, error);
      case 'email':
        return _buildEmailField(currentValue, error);
      case 'phone':
        return _buildPhoneNumberField(currentValue, error);
      case 'address':
        return _buildTextField(currentValue, error);
      case 'postalCode':
        return _buildPostalCodeTextField(currentValue, error);
      default:
        return _buildTextField(currentValue, error);
    }
  }

  String? _dropdownValue;
  Widget _buildEditableField({
    required String label,
    required String currentValue,
    required String field,
    required String error,
  }) {
    final _formKey = GlobalKey<FormState>();
    if (field == 'gender') {
      _dropdownValue ??= (currentValue == 'Female' || currentValue == 'Male')
          ? currentValue
          : 'Custom';

      if (_editValue == null && _dropdownValue == 'Custom') {
        _editValue = currentValue;
      }
    }

    return Form(
      key: _formKey,
      child: Column(
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
                            _editValue = currentValue;
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
                        if (_dropdownValue == null ||
                            _dropdownValue.isEmpty ||
                            _dropdownValue == currentValue) {
                          return AppConstants.newGenderError;
                        }
                        return null;
                      },
                    ),
                  ),
                  if (_dropdownValue == 'Custom') ...[
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                          initialValue: currentValue,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onChanged: (newValue) {
                            _editValue = newValue;
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == currentValue) {
                              return AppConstants.newGenderError;
                            }
                            return null;
                          }),
                    ),
                  ]
                ] else if (field == 'city') ...[
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedCity,
                      items: _cities!.map((City city) {
                        return DropdownMenuItem<int>(
                          value: city.id,
                          child: Text(city.name),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCity = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppRadius.textFieldRadius),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return AppConstants.cityError;
                        }
                        return null;
                      },
                    ),
                  )
                ] else ...[
                  Expanded(
                    child: _customTextFormField(
                        field: field, currentValue: currentValue, error: error),
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
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        _updateUser(field);
                        await Provider.of<UserProvider>(context, listen: false)
                            .updateByToken(user: _userUpdate!)
                            .then((_) {
                          Provider.of<CarRepairShopProvider>(context,
                                  listen: false)
                              .getByToken();
                          setState(() {
                            _editValue = null;
                            _dropdownValue = null;
                          });
                          _toggleEdit(field);
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
                  child: const Text('Apply'),
                ),
              ],
            )
          else
            ListTile(
              title: Text(currentValue),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _toggleEdit(field),
              ),
            ),
          const Divider(),
        ],
      ),
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

  Widget _buildPasswordField(
      TextEditingController controller, String labelText, String errorText,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
      ],
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return errorText;
        }
        if (value.trim().length != value.length) {
          return "Passwords can't have leading or trailing whitespaces";
        }
        if (value.length > 30) {
          return "Password can't be longer than 30 characters";
        }
        if (value.length < 6) {
          return "Password should be at least 6 characters long";
        }
        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
          return "Password must contain at least one letter and one number";
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(
      TextEditingController controller, String labelText, String errorText,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please confirm password";
        }
        if (value != _newPasswordController.text) {
          return errorText;
        }
        return null;
      },
    );
  }

  void _showChangePasswordForm() {
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _oldPasswordController,
                    decoration:
                        const InputDecoration(labelText: 'Old Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppConstants.passwordError;
                      }
                      return null;
                    },
                  ),
                  _buildPasswordField(_newPasswordController,
                      AppConstants.passwordLabel, AppConstants.passwordError,
                      obscureText: true),
                  _buildConfirmPasswordField(
                      _confirmNewPasswordController,
                      AppConstants.passwordConfirmLabel,
                      AppConstants.passwordConfirmError,
                      obscureText: true)
                ],
              ),
            ),
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
                if (_formKey.currentState?.validate() ?? false) {
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
                    Navigator.of(context).pop();
                    _oldPasswordController.clear();
                    _newPasswordController.clear();
                    _confirmNewPasswordController.clear();
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

  void _showChangeUsernameForm(String currentValue) {
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Username'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration:
                        const InputDecoration(labelText: 'New Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppConstants.usernameError;
                      }
                      if (value == currentValue) {
                        return "New username can't be the same as the old one";
                      }
                      if (num.tryParse(value) is num) {
                        return "Usernames can't be numeric";
                      }
                      if (value.length > 25) {
                        return "Username can't be longer than 25 characters";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        labelText: AppConstants.passwordLabel),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppConstants.passwordError;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
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
                if (_formKey.currentState?.validate() ?? false) {
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
                    Navigator.of(context).pop();
                    _usernameController.clear();
                    _passwordController.clear();
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
    if (newTime != null) {
      final openingMinutes = newTime.hour * 60 + newTime.minute;
      final closingMinutes = _closingTime.hour * 60 + _closingTime.minute;

      final differenceInMinutes = closingMinutes - openingMinutes;

      if (differenceInMinutes >= 240) {
        setState(() {
          _openingTime = newTime;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Opening time must be at least 4 hours earlier than the closing time!"),
        ));
      }
    }
  }

  Future<void> _selectClosingTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _closingTime,
    );
    if (newTime != null) {
      final openingMinutes = _openingTime.hour * 60 + _openingTime.minute;
      final closingMinutes = newTime.hour * 60 + newTime.minute;

      final differenceInMinutes = closingMinutes - openingMinutes;

      if (differenceInMinutes >= 240) {
        setState(() {
          _closingTime = newTime;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Closing time must be at least 4 hours after the opening time!"),
        ));
      }
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
        _employees!);
    await Provider.of<CarRepairShopProvider>(context, listen: false)
        .updateWorkDetails(updateWorkDetails: updateWorkDetails)
        .then((_) {
      Provider.of<CarRepairShopProvider>(context, listen: false).getByToken();
    });
  }

  List<List<dynamic>>? _reportData;
  String? _csvReport;
  String? _selectedReservationType;
  String? _username;
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _fetchReport() async {
    if (mounted) {
      try {
        final report =
            await Provider.of<CarRepairShopProvider>(context, listen: false)
                .getReport();

        if (report != null && report.isNotEmpty) {
          if (mounted) {
            setState(() {
              _reportData = _parseCsvReport(report);
              _csvReport = report;
            });
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _saveReportToFile() async {
    if (_csvReport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No report available to save.')),
      );
      return;
    }

    try {
      String? savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select a location to save your report',
        fileName: 'report.csv',
      );

      if (savePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Save operation cancelled.')),
        );
        return;
      }

      final file = File(savePath);
      await file.writeAsString(_csvReport!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report saved to $savePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save report.')),
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
              title: const Text('Generate Report'),
              content: SizedBox(
                  width: 450,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Optional filters:'),
                      const SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        value: _selectedReservationType,
                        decoration: const InputDecoration(
                            labelText: "Select Reservation Type"),
                        items: const [
                          DropdownMenuItem(value: null, child: Text("All")),
                          DropdownMenuItem(
                              value: "Repairs", child: Text("Repairs")),
                          DropdownMenuItem(
                              value: "Diagnostics", child: Text("Diagnostics")),
                          DropdownMenuItem(
                              value: "Repairs and Diagnostics",
                              child: Text("Repairs and Diagnostics")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedReservationType = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Customer username"),
                        onChanged: (value) {
                          setState(() {
                            _username = value;
                          });
                        },
                      ),
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
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                          'Note: This will start a report generating process. Once done, you will be notified and new report will be ready to save to CSV.'),
                    ],
                  )),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _endDate = null;
                      _startDate = null;
                      _username = null;
                    });
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

  List<List<dynamic>> _parseCsvReport(String csvData) {
    return CsvToListConverter().convert(csvData);
  }

  Future<void> _updateMonthlyStatistics() async {
    await Provider.of<CarRepairShopProvider>(context, listen: false)
        .updateMonthlyStatistics();
  }

  Future<void> _generateReport() async {
    final filter = ReportFilter(
      _selectedReservationType,
      _username,
      _startDate,
      _endDate,
    );
    await Provider.of<CarRepairShopProvider>(context, listen: false)
        .generateReport(filter: filter);
  }

  final List<String> _chartTypes = [
    'Revenue per reservation type',
    'Daily revenue',
    'Revenue per top 10 customers',
    'Top 10 reservations'
  ];

  void _updateMonthlyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Monthly Statistics'),
              content: const SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Note: This will start a report generating process for monthly statistics. Once done, you will be notified and new monthly statistics will be displayed.'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _updateMonthlyStatistics();
                  },
                  child: const Text('Generate'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteImage() async {
    bool delete = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Delete Image'),
              content: const SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Are you sure to delete the image?'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    delete = false;
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    delete = true;
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      },
    );

    if (delete) {
      setState(() {
        _updateImage = UserUpdateImage("");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      showBackButton: false,
      child: Consumer<CarRepairShopProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;

          if (user != null && !_isInitialized) {
            _selectedCity = user.cityId;
            _selectedWorkDays = parseWorkDays(user.workDays);
            _openingTime = parseTimeOfDay(user.openingTime);
            _closingTime = parseTimeOfDay(user.closingTime);
            _employees = user.employees;
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
                                        if (_updateImage != null) ...[
                                          if (_updateImage!.image != "")
                                            CircleAvatar(
                                              backgroundImage: MemoryImage(
                                                  base64Decode(
                                                      _updateImage!.image)),
                                              radius: 50,
                                            )
                                          else
                                            const CircleAvatar(
                                              radius: 50,
                                              child:
                                                  Icon(Icons.person, size: 50),
                                            ),
                                        ] else if (user.image != null &&
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
                                          bottom: -10,
                                          right: -10,
                                          child: IconButton(
                                            icon: const Icon(Icons.camera_alt),
                                            onPressed: _pickImage,
                                          ),
                                        ),
                                        if (user.image != null &&
                                            user.image!.isNotEmpty)
                                          Positioned(
                                            bottom: -10,
                                            left: -10,
                                            child: IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: _deleteImage,
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
                                                    Provider.of<CarRepairShopProvider>(
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
                                        currentValue: user.name,
                                        field: 'name',
                                        error: AppConstants.nameError),
                                    _buildEditableField(
                                        label: 'Surname',
                                        currentValue: user.surname,
                                        field: 'surname',
                                        error: AppConstants.surnameError),
                                    _buildEditableField(
                                        label: 'Gender',
                                        currentValue: user.gender,
                                        field: 'gender',
                                        error: AppConstants.newGenderError),
                                    const SizedBox(height: 16.0),
                                    const Text.rich(TextSpan(
                                        text: 'Company Details',
                                        style: TextStyle(fontSize: 18))),
                                    const SizedBox(height: 8.0),
                                    _buildEditableField(
                                        label: 'Email',
                                        currentValue: user.email,
                                        field: 'email',
                                        error: AppConstants.emailError),
                                    _buildEditableField(
                                        label: 'Phone',
                                        currentValue: user.phone,
                                        field: 'phone',
                                        error: AppConstants.phoneError),
                                    _buildEditableField(
                                        label: 'Address',
                                        currentValue: user.address,
                                        field: 'address',
                                        error: AppConstants.addressError),
                                    _buildEditableField(
                                        label: 'Postal Code',
                                        currentValue: user.postalCode,
                                        field: 'postalCode',
                                        error: AppConstants.postalCodeError),
                                    _buildEditableField(
                                        label: 'City',
                                        currentValue: user.city,
                                        field: 'city',
                                        error: AppConstants.cityError),
                                    const SizedBox(height: 16.0),
                                    const Text.rich(TextSpan(
                                        text: 'Work Details',
                                        style: TextStyle(fontSize: 18))),
                                    if (_employees != null) ...[
                                      const SizedBox(height: 8.0),
                                      const Text.rich(TextSpan(
                                          text: 'Number of Employees:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500))),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: _employees! > 1
                                                ? () {
                                                    setState(() {
                                                      _employees =
                                                          _employees! - 1;
                                                    });
                                                  }
                                                : null,
                                            icon: const Icon(Icons.remove),
                                          ),
                                          Text('$_employees',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _employees = _employees! + 1;
                                              });
                                            },
                                            icon: const Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                    ],
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
                                      onPressed: _selectedWorkDays.isNotEmpty
                                          ? () {
                                              _updateWorkDetails();
                                            }
                                          : null,
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
                                        _showChangeUsernameForm(user.username);
                                      },
                                      icon: const Icon(Icons.person),
                                      label: const Text('Change Username'),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_reportData != null) ...[
                                Text(
                                  'Custom Report Ready:',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(width: 5),
                                ElevatedButton(
                                  onPressed: _saveReportToFile,
                                  child: const Text(
                                      'Save custom report data to CSV'),
                                ),
                              ] else ...[
                                Text(
                                  'Custom Report Not Available:',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _openFilterDialog,
                                child: const Text('Generate New Custom Report'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Expanded(
                              child: SingleChildScrollView(
                                  child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Monthly Statistics:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
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
                                        _chartFuture = buildChart(
                                            _selectedChartType, context);
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: _updateMonthlyDialog,
                                    child:
                                        const Text('Update Monthly Statistics'),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              FutureBuilder<Widget>(
                                future: _chartFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot<Widget> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text('${snapshot.error}'));
                                  } else if (snapshot.hasData) {
                                    return snapshot.data!;
                                  } else {
                                    return const Center(
                                        child: Text('No data available'));
                                  }
                                },
                              ),
                            ],
                          ))),
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

  @override
  void dispose() {
    _notificationService.stopConnection();
    super.dispose();
  }
}
