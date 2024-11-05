import 'package:fixmycar_client/constants.dart';
import 'package:fixmycar_client/src/models/user/user_update.dart';
import 'package:fixmycar_client/src/models/user/user_update_image.dart';
import 'package:fixmycar_client/src/models/user/user_update_password.dart';
import 'package:fixmycar_client/src/models/user/user_update_username.dart';
import 'package:fixmycar_client/src/providers/auth_provider.dart';
import 'package:fixmycar_client/src/providers/client_provider.dart';
import 'package:fixmycar_client/src/screens/login_screen.dart';
import 'package:fixmycar_client/src/utilities/phone_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_client/src/providers/user_provider.dart';
import 'master_screen.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserUpdate? _userUpdate;
  String? _editingField;
  String? _editValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ClientProvider>(context, listen: false).getByToken();
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
      case 'city':
        return _buildTextField(currentValue, error);
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
                          borderRadius: BorderRadius.circular(12.0),
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
                      _updateUser(field);
                      await Provider.of<UserProvider>(context, listen: false)
                          .updateByToken(user: _userUpdate!)
                          .then((_) {
                        Provider.of<ClientProvider>(context, listen: false)
                            .getByToken();
                        setState(() {
                          _editValue = null;
                          _dropdownValue = null;
                        });
                        _toggleEdit(field);
                      });
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
                  // Step 3: Validate the form
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
      child: Consumer<ClientProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (userProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (user != null) ...[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_updateImage != null) ...[
                        if (_updateImage!.image != "")
                          CircleAvatar(
                            backgroundImage:
                                MemoryImage(base64Decode(_updateImage!.image)),
                            radius: 50,
                          )
                        else
                          const CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person, size: 50),
                          ),
                      ] else if (user.image != null && user.image!.isNotEmpty)
                        CircleAvatar(
                          backgroundImage:
                              MemoryImage(base64Decode(user.image!)),
                          radius: 50,
                        )
                      else
                        const CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person, size: 50),
                        ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: _pickImage,
                        ),
                      ),
                      if (user.image != null && user.image!.isNotEmpty)
                        Positioned(
                          bottom: -5,
                          left: -5,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: _deleteImage,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(user.username),
                  if (_updateImage != null) ...[
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                await Provider.of<UserProvider>(context,
                                        listen: false)
                                    .updateImage(updateImage: _updateImage!)
                                    .then((_) {
                                  setState(() {
                                    _updateImage = null;
                                  });
                                  Provider.of<ClientProvider>(context,
                                          listen: false)
                                      .getByToken();
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                          child: const Text('Save Changes'),
                        ),
                      ],
                    ),
                  ],
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
                  const SizedBox(height: 8.0),
                  const Text.rich(TextSpan(
                      text: 'Account', style: TextStyle(fontSize: 18))),
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
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
