import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fixmycar_admin/constants.dart';
import 'package:fixmycar_admin/src/models/user/user.dart';
import 'package:fixmycar_admin/src/models/user/user_search_object.dart';
import 'package:fixmycar_admin/src/models/user/user_update.dart';
import 'package:fixmycar_admin/src/models/user/user_update_image.dart';
import 'package:fixmycar_admin/src/models/user/user_update_password.dart';
import 'package:fixmycar_admin/src/models/user/user_update_username.dart';
import 'package:fixmycar_admin/src/providers/admin_provider.dart';
import 'package:fixmycar_admin/src/providers/auth_provider.dart';
import 'package:fixmycar_admin/src/providers/user_provider.dart';
import 'package:fixmycar_admin/src/screens/chat_screen.dart';
import 'package:fixmycar_admin/src/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'master_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AdminProvider>(context, listen: false).getByToken();
      if (mounted) {
        await _fetchUsers();
      }
    });
  }

  UserSearchObject _searchObject =
      UserSearchObject(null, null, 'allexceptadmin');
  List<User> _users = [];
  bool _isLoading = false;

  Future<void> _fetchUsers() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      final provider = Provider.of<UserProvider>(context, listen: false);
      await provider.getUsers(search: _searchObject);
      if (provider.isLoading == false) {
        final users = provider.users;
        if (mounted) {
          setState(() {
            _users = users;
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _changeActiveStatus(int userId, String username) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: Text(
            'Are you sure that you want to change the activity status for $username?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<UserProvider>(context, listen: false)
                    .changeActiveStatus(userId)
                    .then((_) async {
                  await _fetchUsers();
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')));
              }
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  void _updateRoleFilter({String? role}) {
    if (mounted) {
      setState(() {
        if (role != null) {
          _searchObject.role = role;
        } else {
          _searchObject.role = 'allexceptadmin';
        }
      });
      _fetchUsers();
    }
  }

  void _updateStatusFilter({bool? active}) {
    if (mounted) {
      setState(() {
        _searchObject.active = active;
      });
      _fetchUsers();
    }
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

  UserUpdate? _userUpdate;
  String? _editingField;
  String? _editValue;

  void _toggleEdit(String field) {
    setState(() {
      _editingField = _editingField == field ? null : field;
    });
  }

  void _updateUser(String field) {
    _userUpdate = UserUpdate(null, null, null, null, null);
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
                      Provider.of<AdminProvider>(context, listen: false)
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

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      showBackButton: false,
      child: Consumer<AdminProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
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
                      height: double.infinity,
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
                                                    Provider.of<AdminProvider>(
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
                                    const SizedBox(height: 8.0),
                                    const Text.rich(TextSpan(
                                        text: 'Account',
                                        style: TextStyle(fontSize: 18))),
                                    const SizedBox(height: 8.0),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _showChangeUsernameForm();
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
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account Management',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                children: [
                                  DropdownButton<String>(
                                    value: _searchObject.role,
                                    hint: const Text('Filter by Role'),
                                    onChanged: (value) {
                                      _updateRoleFilter(role: value);
                                    },
                                    items: const [
                                      DropdownMenuItem<String>(
                                        value: 'allexceptadmin',
                                        child: Text('All'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'carrepairshop',
                                        child: Text('Car Repair Shop'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'carpartsshop',
                                        child: Text('Car Parts Shop'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'client',
                                        child: Text('Client'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  DropdownButton<bool>(
                                    value: _searchObject.active,
                                    hint: const Text('Filter by Status'),
                                    onChanged: (value) {
                                      _updateStatusFilter(active: value);
                                    },
                                    items: const [
                                      DropdownMenuItem<bool>(
                                        value: null,
                                        child: Text('All'),
                                      ),
                                      DropdownMenuItem<bool>(
                                        value: true,
                                        child: Text('Active'),
                                      ),
                                      DropdownMenuItem<bool>(
                                        value: false,
                                        child: Text('Inactive'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : _buildUserTable(),
                            ],
                          ),
                        ),
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

  Widget _buildUserTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Mail')),
              DataColumn(label: Text('Created On')),
              DataColumn(label: Text('Role')),
              DataColumn(label: Text('Active')),
              DataColumn(label: Text('Manage')),
              DataColumn(label: Text('Message')),
            ],
            rows: _users.map<DataRow>((user) {
              return DataRow(cells: [
                DataCell(
                    Text('${user.username} (${user.name} ${user.surname})')),
                DataCell(Text(user.email)),
                DataCell(Text(_formatDate(user.created))),
                DataCell(Text(user.role == "carrepairshop"
                    ? "Car Repair Shop"
                    : "Car Parts Shop")),
                DataCell(Text(user.active ? 'Yes' : 'No')),
                DataCell(
                  ElevatedButton(
                    onPressed: () =>
                        _changeActiveStatus(user.id, user.username),
                    child: Text(user.active ? 'Deactivate' : 'Activate'),
                  ),
                ),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            recipientUserId: user.username,
                          ),
                        ),
                      );
                    },
                    child: const Text('Message'),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
