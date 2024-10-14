import 'package:fixmycar_car_parts_shop/src/providers/car_parts_shop_provider.dart';
import 'package:fixmycar_car_parts_shop/src/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_parts_shop/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'master_screen.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_register.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _customGenderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedImagePath;
  String _gender = 'Female';

  TimeOfDay _openingTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _closingTime = TimeOfDay(hour: 16, minute: 0);
  List<int> _selectedWorkDays = [0, 1, 2, 3, 4];

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
          Provider.of<CarPartsShopProvider>(context, listen: false);
      try {
        final newUser = UserRegister(
          _nameController.text,
          _surnameController.text,
          _emailController.text,
          _phoneController.text,
          _usernameController.text,
          _gender == 'Custom' ? _customGenderController.text : _gender,
          _addressController.text,
          _postalCodeController.text,
          _passwordController.text,
          _passwordConfirmController.text,
          _convertImageToBase64(_selectedImagePath),
          _cityController.text,
          _selectedWorkDays,
          'PT${_openingTime.hour}H${_openingTime.minute}M',
          'PT${_closingTime.hour}H${_closingTime.minute}M',
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
              color: Theme.of(context).colorScheme.surfaceContainerLow,
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
                        _buildTextField(
                            _passwordController,
                            AppConstants.passwordLabel,
                            AppConstants.passwordError,
                            obscureText: true),
                        const SizedBox(height: 16.0),
                        _buildTextField(
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
                        _buildTextField(_emailController,
                            AppConstants.emailLabel, AppConstants.emailError,
                            keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 16.0),
                        _buildTextField(_phoneController,
                            AppConstants.phoneLabel, AppConstants.phoneError,
                            keyboardType: TextInputType.phone),
                        const SizedBox(height: 16.0),
                        _buildTextField(
                            _addressController,
                            AppConstants.addressLabel,
                            AppConstants.addressError),
                        const SizedBox(height: 16.0),
                        _buildTextField(
                            _postalCodeController,
                            AppConstants.postalCodeLabel,
                            AppConstants.postalCodeError),
                        const SizedBox(height: 16.0),
                        _buildTextField(_cityController, AppConstants.cityLabel,
                            AppConstants.cityError),
                        const SizedBox(height: 24.0),
                        _buildSectionTitle(context, 'Work Details'),
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
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHigh,
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
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
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
