import 'package:fixmycar_car_parts_shop/src/models/user/user_update.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/user_provider.dart';
import 'master_screen.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _editingField;
  UserUpdate? _userUpdate;
  String? _editValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<UserProvider>(context, listen: false).getByToken();
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

  Widget _buildEditableField({
    required String label,
    required String value,
    required String field,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4.0),
        if (_editingField == field)
          Row(
            children: [
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
              const SizedBox(width: 8.0),
              TextButton(
                onPressed: () => _toggleEdit(field),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  _toggleEdit(field);
                  if (_editValue != null && _editValue!.isNotEmpty) {
                    _updateUser(field);
                    await Provider.of<UserProvider>(context, listen: false)
                        .updateByToken(
                            user: _userUpdate!,
                            toJson: (UserUpdate user) => user.toJson())
                        .then((_) {
                      Provider.of<UserProvider>(context, listen: false)
                          .getByToken();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Input required!"),
                      ),
                    );
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

  Future<void> _pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      //TODO: Logic to handle file upload
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = userProvider.user;
          if (user != null) {
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
                        width: 350,
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
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (user.image != null &&
                                          user.image != '')
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
                                  const SizedBox(height: 8.0),
                                  Text.rich(TextSpan(
                                    text: user.username,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )),
                                  const SizedBox(height: 16.0),
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
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      //TODO: Change username logic
                                    },
                                    icon: const Icon(Icons.person),
                                    label: const Text('Change Username'),
                                  ),
                                  const SizedBox(height: 8.0),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      //TODO: Change password logic
                                    },
                                    icon: const Icon(Icons.lock),
                                    label: const Text('Change Password'),
                                  ),
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
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.bar_chart,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(
                                    'Business Reports',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'In development...',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            return const Card(
              child: Center(
                child: Text('Failed loading user information.'),
              ),
            );
          }
        },
      ),
    );
  }
}
