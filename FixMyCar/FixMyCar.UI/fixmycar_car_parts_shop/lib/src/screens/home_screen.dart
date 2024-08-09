import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/user_provider.dart';
import 'master_screen.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _editingField;

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

  Widget _buildEditableField({
    required String label,
    required String value,
    required String field,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _toggleEdit(field),
          child: Chip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                const SizedBox(width: 4),
                const Icon(Icons.edit, size: 16),
              ],
            ),
            backgroundColor: Theme.of(context).cardColor,
          ),
        ),
        if (_editingField == field)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextFormField(
              initialValue: value,
              decoration: InputDecoration(
                labelText: 'Edit $label',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onFieldSubmitted: (newValue) {
                _toggleEdit(field);
              },
            ),
          ),
      ],
    );
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
                      Expanded(
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (user.image != null && user.image != '')
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
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _toggleEdit('image'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                _buildEditableField(
                                  label: '${user.name} ${user.surname}',
                                  value: '${user.name} ${user.surname}',
                                  field: 'name',
                                ),
                                const SizedBox(height: 8.0),
                                _buildEditableField(
                                  label: 'Gender: ${user.gender}',
                                  value: user.gender,
                                  field: 'gender',
                                ),
                                const SizedBox(height: 8.0),
                                _buildEditableField(
                                  label: 'Company Name: ${user.username}',
                                  value: user.username,
                                  field: 'username',
                                ),
                                const SizedBox(height: 8.0),
                                _buildEditableField(
                                  label: 'Email: ${user.email}',
                                  value: user.email,
                                  field: 'email',
                                ),
                                const SizedBox(height: 8.0),
                                _buildEditableField(
                                  label: 'Phone: ${user.phone}',
                                  value: user.phone,
                                  field: 'phone',
                                ),
                                const SizedBox(height: 8.0),
                                _buildEditableField(
                                  label: 'Address: ${user.address}',
                                  value: user.address,
                                  field: 'address',
                                ),
                                const SizedBox(height: 8.0),
                                _buildEditableField(
                                  label: 'Postal Code: ${user.postalCode}',
                                  value: user.postalCode,
                                  field: 'postalCode',
                                ),
                                const SizedBox(height: 8.0),
                                _buildEditableField(
                                  label: 'City: ${user.city}',
                                  value: user.city,
                                  field: 'city',
                                ),
                              ],
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
