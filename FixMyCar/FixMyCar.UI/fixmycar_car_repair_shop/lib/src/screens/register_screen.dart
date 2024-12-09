import 'package:fixmycar_car_repair_shop/src/models/city/city.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_repair_shop_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/city_provider.dart';
import 'package:fixmycar_car_repair_shop/src/screens/login_screen.dart';
import 'package:fixmycar_car_repair_shop/src/utilities/phone_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_repair_shop/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'master_screen.dart';
import 'package:fixmycar_car_repair_shop/src/models/user/user_register.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<City>? _cities;
  int? _selectedCity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchCities();
    });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _customGenderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedImagePath;
  String _gender = 'Female';
  int _employees = 1;
  TimeOfDay _openingTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _closingTime = TimeOfDay(hour: 16, minute: 0);
  List<int> _selectedWorkDays = [0, 1, 2, 3, 4];

  Future _fetchCities() async {
    if (mounted) {
      var cityProvider = Provider.of<CityProvider>(context, listen: false);
      await cityProvider.getCities().then((_) {
        setState(() {
          _cities = cityProvider.cities;
          _selectedCity = _cities![0].id;
        });
      });
    }
  }

  Future<void> _pickImage() async {
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (pickedFile != null && pickedFile.files.single.path != null) {
      setState(() {
        _selectedImagePath = pickedFile.files.single.path;
      });
    }
  }

  String? _convertImageToBase64(String? imagePath) {
    if (imagePath == null) return null;
    final bytes = File(imagePath).readAsBytesSync();
    return base64Encode(bytes);
  }

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final userProvider =
          Provider.of<CarRepairShopProvider>(context, listen: false);
      try {
        final newUser = UserRegister(
          _nameController.text,
          _surnameController.text,
          _emailController.text,
          "+387 ${_phoneController.text}",
          _usernameController.text,
          _gender == 'Custom' ? _customGenderController.text : _gender,
          _addressController.text,
          _postalCodeController.text,
          _passwordController.text,
          _passwordConfirmController.text,
          _convertImageToBase64(_selectedImagePath),
          _selectedCity != null ? _selectedCity! : 1,
          _selectedWorkDays,
          'PT${_openingTime.hour}H${_openingTime.minute}M',
          'PT${_closingTime.hour}H${_closingTime.minute}M',
          _employees,
        );
        await userProvider.insertUser(newUser);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectOpeningTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _openingTime,
    );

    if (newTime != null) {
      if ((newTime.hour < _closingTime.hour ||
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
  }

  Future<void> _selectClosingTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _closingTime,
    );

    if (newTime != null) {
      if ((newTime.hour > _openingTime.hour ||
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
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      showBackButton: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.defaultPadding),
          child: SizedBox(
            width: 700,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
              ),
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.defaultPadding),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppConstants.registerLabel,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 24.0),
                        _selectedImagePath != null
                            ? Image.file(File(_selectedImagePath!), height: 150)
                            : const Icon(Icons.image, size: 150),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Pick Profile Image'),
                        ),
                        const SizedBox(height: 24.0),
                        _buildSectionTitle(context, 'Personal Details'),
                        const SizedBox(height: 16.0),
                        _buildTextField(_nameController, AppConstants.nameLabel,
                            AppConstants.nameError),
                        const SizedBox(height: 16.0),
                        _buildTextField(
                            _surnameController,
                            AppConstants.surnameLabel,
                            AppConstants.surnameError),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          items:
                              ['Female', 'Male', 'Custom'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _gender = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: AppConstants.genderLabel,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppRadius.textFieldRadius),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppConstants.genderError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        if (_gender == 'Custom') ...[
                          _buildTextField(_customGenderController,
                              'Custom Gender', 'Please enter your gender'),
                          const SizedBox(height: 16.0),
                        ],
                        _buildPasswordField(
                            _passwordController,
                            AppConstants.passwordLabel,
                            AppConstants.passwordError,
                            obscureText: true),
                        const SizedBox(height: 16.0),
                        _buildConfirmPasswordField(
                            _passwordConfirmController,
                            AppConstants.passwordConfirmLabel,
                            AppConstants.passwordConfirmError,
                            obscureText: true),
                        const SizedBox(height: 24.0),
                        _buildSectionTitle(context, 'Company Details'),
                        const SizedBox(height: 16.0),
                        _buildTextField(
                            _usernameController,
                            AppConstants.usernameLabel,
                            AppConstants.usernameError),
                        const SizedBox(height: 16.0),
                        _buildEmailField(_emailController,
                            AppConstants.emailLabel, AppConstants.emailError),
                        const SizedBox(height: 16.0),
                        _buildPhoneNumberField(
                          _phoneController,
                          AppConstants.phoneLabel,
                          AppConstants.phoneError,
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextField(
                            _addressController,
                            AppConstants.addressLabel,
                            AppConstants.addressError),
                        const SizedBox(height: 16.0),
                        _buildPostalCodeField(
                            _postalCodeController,
                            AppConstants.postalCodeLabel,
                            AppConstants.postalCodeError),
                        const SizedBox(height: 16.0),
                        if (_cities != null && _cities!.isNotEmpty) ...[
                          DropdownButtonFormField<int>(
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
                              labelText: AppConstants.cityLabel,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppRadius.textFieldRadius),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return AppConstants.cityError;
                              }
                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: 24.0),
                        _buildSectionTitle(context, 'Work Details'),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Number of employees:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            IconButton(
                              onPressed: _employees > 1
                                  ? () {
                                      setState(() {
                                        _employees = _employees - 1;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.remove),
                            ),
                            Text('$_employees',
                                style: Theme.of(context).textTheme.bodyLarge),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _employees = _employees + 1;
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        _buildWorkDaysSelector(),
                        const SizedBox(height: 16.0),
                        _buildTimePicker(
                            'Opening Time', _openingTime, _selectOpeningTime),
                        const SizedBox(height: 16.0),
                        _buildTimePicker(
                            'Closing Time', _closingTime, _selectClosingTime),
                        const SizedBox(height: 24.0),
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        const SizedBox(height: 8.0),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _selectedWorkDays.isNotEmpty
                                    ? () {
                                        _register();
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.buttonRadius),
                                  ),
                                ),
                                child: const Text(
                                    AppConstants.registerButtonLabel),
                              ),
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                              "Already have an account? Login here."),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkDaysSelector() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: List.generate(7, (index) {
        final day = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][index];
        final dayIndex = index;
        return ChoiceChip(
          label: Text(day),
          selected: _selectedWorkDays.contains(dayIndex),
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

  Widget _buildPhoneNumberField(
      TextEditingController controller, String labelText, String errorText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixText: '+387 ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textFieldRadius),
        ),
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        PhoneNumberFormatter(),
        LengthLimitingTextInputFormatter(12),
      ],
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return errorText;
        }
        if (!RegExp(r'^\d{8,9}$').hasMatch(value.replaceAll(' ', ''))) {
          return "Phone number must be 8 or 9 digits";
        }
        return null;
      },
    );
  }

  Widget _buildPostalCodeField(
      TextEditingController controller, String labelText, String errorText,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
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
        if (value.length > 25) {
          return "This value can't be longer than 25 characters";
        }
        return null;
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, String errorText,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
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

  Widget _buildEmailField(
      TextEditingController controller, String labelText, String errorText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textFieldRadius),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        LengthLimitingTextInputFormatter(40),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return "Please enter a valid email address";
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textFieldRadius),
        ),
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
        if (value != _passwordController.text) {
          return errorText;
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller, String labelText, String errorText,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textFieldRadius),
        ),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
