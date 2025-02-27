import 'package:fixmycar_admin/constants.dart';
import 'package:fixmycar_admin/src/models/city/city.dart';
import 'package:fixmycar_admin/src/models/city/city_insert_update.dart';
import 'package:fixmycar_admin/src/models/user/user.dart';
import 'package:fixmycar_admin/src/models/user/user_minimal.dart';
import 'package:fixmycar_admin/src/models/user/user_search_object.dart';
import 'package:fixmycar_admin/src/models/user/user_update.dart';
import 'package:fixmycar_admin/src/providers/admin_provider.dart';
import 'package:fixmycar_admin/src/providers/city_provider.dart';
import 'package:fixmycar_admin/src/providers/recommender_provider.dart';
import 'package:fixmycar_admin/src/providers/user_provider.dart';
import 'package:fixmycar_admin/src/screens/chat_screen.dart';
import 'package:fixmycar_admin/src/utilities/phone_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'master_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageNumber = 1;
  final int _pageSize = 10;
  int _totalPages = 1;
  int _countOfUsers = 0;

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
      await provider.getUsers(
          pageNumber: _pageNumber, pageSize: _pageSize, search: _searchObject);
      if (provider.isLoading == false) {
        final users = provider.users;
        final count = provider.countOfItems;
        if (mounted) {
          setState(() {
            _users = users;
            _countOfUsers = count;
            _totalPages = (count / _pageSize).ceil();
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<UserProvider>(context, listen: false)
                    .changeActiveStatus(userId)
                    .then((_) async {
                  await _fetchUsers();
                }).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Activity status changed successfully!")));
                });
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCity(City city) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: Text(
            'Are you sure that you want to delete ${city.name} from the system?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<CityProvider>(context, listen: false)
                    .deleteCity(city.id)
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("City deleted successfully")));
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "Can't delete a city that is currently in use (e.g., accounts, orders...)")));
              }
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
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
        _pageNumber = 1;
      });
      _fetchUsers();
    }
  }

  void _updateStatusFilter({bool? active}) {
    if (mounted) {
      setState(() {
        _searchObject.active = active;
        _pageNumber = 1;
      });
      _fetchUsers();
    }
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
      default:
        return _buildTextField(currentValue, error);
    }
  }

  Widget _buildEditableField({
    required String label,
    required String currentValue,
    required String field,
    required String error,
  }) {
    final _formKey = GlobalKey<FormState>();

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
                Expanded(
                  child: _customTextFormField(
                      field: field, currentValue: currentValue, error: error),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    _toggleEdit(field);
                    setState(() {
                      _editValue = null;
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
                          Provider.of<AdminProvider>(context, listen: false)
                              .getByToken();
                          setState(() {
                            _editValue = null;
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

  Future<void> _trainOrdersRecommender() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: const Text(
            'Are you sure that you want to start training orders recommender system?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<RecommenderProvider>(context, listen: false)
                    .trainOrdersModel()
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Training initiated successfully!"),
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
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> _trainReservationsRecommender() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: const Text(
            'Are you sure that you want to start training reservations recommender system?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<RecommenderProvider>(context, listen: false)
                    .trainReservationsModel()
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Training initiated successfully!"),
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
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> _showInsertUpdateForm(City? city, bool edit) {
    final formKey = GlobalKey<FormState>();

    final cityController = TextEditingController();

    cityController.text = edit ? city!.name : "";

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(edit ? "Edit City" : "Add City"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: cityController,
                    decoration: InputDecoration(
                        labelText: edit ? "New Name" : "New City Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a city name";
                      }
                      if (num.tryParse(value) is num) {
                        return "City names can't be numeric";
                      }
                      if (value.length > 25) {
                        return "City name can't be longer than 25 characters";
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                cityController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  CityInsertUpdate newCity =
                      CityInsertUpdate(cityController.text);
                  if (edit) {
                    try {
                      await Provider.of<CityProvider>(context, listen: false)
                          .updateCity(city!.id, newCity)
                          .then((_) {
                        cityController.clear();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('City name changed successfully!'),
                          ),
                        );
                      });
                    } catch (e) {
                      Navigator.of(context).pop();
                      cityController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  } else {
                    try {
                      await Provider.of<CityProvider>(context, listen: false)
                          .insertCity(newCity)
                          .then((_) {
                        cityController.clear();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('City added successfully!'),
                          ),
                        );
                      });
                    } catch (e) {
                      Navigator.of(context).pop();
                      cityController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
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

  Future<void> _manangeCities(BuildContext context) async {
    var cityProvider = Provider.of<CityProvider>(context, listen: false);

    List<City> cities = [];
    int pageNumber = 1;
    final int pageSize = 10;
    int totalPages = 1;
    int countOfCities = 0;

    await cityProvider
        .getCities(pageNumber: pageNumber, pageSize: pageSize)
        .then((_) {
      cities = cityProvider.cities;
      countOfCities = cityProvider.countOfItems;
      totalPages = (countOfCities / pageSize).ceil();
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Manage Cities',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16.0),
                      cities.isEmpty
                          ? const Center(
                              child: Text("No cities found."),
                            )
                          : Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  width: double.infinity,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('Name')),
                                      DataColumn(label: Text('Update')),
                                      DataColumn(label: Text('Delete')),
                                    ],
                                    rows: cities.map<DataRow>((city) {
                                      return DataRow(cells: [
                                        DataCell(Text(city.name)),
                                        DataCell(
                                          ElevatedButton(
                                            onPressed: () async {
                                              await _showInsertUpdateForm(
                                                      city, true)
                                                  .then((_) async {
                                                await cityProvider
                                                    .getCities(
                                                        pageNumber: pageNumber,
                                                        pageSize: pageSize)
                                                    .then((_) {
                                                  setState(() {
                                                    cities =
                                                        cityProvider.cities;
                                                    countOfCities = cityProvider
                                                        .countOfItems;
                                                    totalPages =
                                                        (countOfCities /
                                                                pageSize)
                                                            .ceil();
                                                  });
                                                });
                                              });
                                            },
                                            child: const Text('Update'),
                                          ),
                                        ),
                                        DataCell(
                                          ElevatedButton(
                                            onPressed: () async {
                                              await _deleteCity(city)
                                                  .then((_) async {
                                                await cityProvider
                                                    .getCities(
                                                        pageNumber: pageNumber,
                                                        pageSize: pageSize)
                                                    .then((_) {
                                                  setState(() {
                                                    cities =
                                                        cityProvider.cities;
                                                    countOfCities = cityProvider
                                                        .countOfItems;
                                                    totalPages =
                                                        (countOfCities /
                                                                pageSize)
                                                            .ceil();
                                                  });
                                                });
                                              });
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                      if (countOfCities != 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: pageNumber > 1
                                  ? () async {
                                      setState(() {
                                        pageNumber = pageNumber - 1;
                                      });
                                      await cityProvider
                                          .getCities(
                                              pageNumber: pageNumber,
                                              pageSize: pageSize)
                                          .then((_) {
                                        setState(() {
                                          cities = cityProvider.cities;
                                          countOfCities =
                                              cityProvider.countOfItems;
                                          totalPages =
                                              (countOfCities / pageSize).ceil();
                                        });
                                      });
                                    }
                                  : null,
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                            ),
                            Text('$pageNumber',
                                style: Theme.of(context).textTheme.bodyLarge),
                            IconButton(
                              onPressed: pageNumber < totalPages
                                  ? () async {
                                      setState(() {
                                        pageNumber = pageNumber + 1;
                                      });
                                      await cityProvider
                                          .getCities(
                                              pageNumber: pageNumber,
                                              pageSize: pageSize)
                                          .then((_) {
                                        setState(() {
                                          cities = cityProvider.cities;
                                          countOfCities =
                                              cityProvider.countOfItems;
                                          totalPages =
                                              (countOfCities / pageSize).ceil();
                                        });
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                            const SizedBox(width: 8.0),
                            ElevatedButton.icon(
                              onPressed: () async {
                                await _showInsertUpdateForm(null, false)
                                    .then((_) async {
                                  await cityProvider
                                      .getCities(
                                          pageNumber: pageNumber,
                                          pageSize: pageSize)
                                      .then((_) {
                                    setState(() {
                                      cities = cityProvider.cities;
                                      countOfCities = cityProvider.countOfItems;
                                      totalPages =
                                          (countOfCities / pageSize).ceil();
                                    });
                                  });
                                });
                              },
                              icon: const Icon(Icons.location_city_rounded),
                              label: const Text('Add a new city'),
                            ),
                          ],
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
                                    const Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          child: Icon(Icons.person, size: 50),
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
                                        label: 'Email',
                                        currentValue: user.email,
                                        field: 'email',
                                        error: AppConstants.emailError),
                                    _buildEditableField(
                                        label: 'Phone',
                                        currentValue: user.phone,
                                        field: 'phone',
                                        error: AppConstants.phoneError),
                                    const SizedBox(height: 8.0),
                                    const Text.rich(TextSpan(
                                        text: 'System',
                                        style: TextStyle(fontSize: 18))),
                                    const SizedBox(height: 8.0),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        await _trainOrdersRecommender();
                                      },
                                      icon: const Icon(Icons.update),
                                      label: const Text(
                                          'Train orders recommender'),
                                    ),
                                    const SizedBox(height: 8.0),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        await _trainReservationsRecommender();
                                      },
                                      icon: const Icon(Icons.update),
                                      label: const Text(
                                          'Train reservations recommender'),
                                    ),
                                    const SizedBox(height: 8.0),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        await _manangeCities(context);
                                      },
                                      icon: const Icon(Icons.update),
                                      label: const Text('Manage Cities'),
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
                              if (_countOfUsers != 0) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: _pageNumber > 1
                                          ? () {
                                              setState(() {
                                                _pageNumber = _pageNumber - 1;
                                                _fetchUsers();
                                              });
                                            }
                                          : null,
                                      icon: const Icon(
                                          Icons.arrow_back_ios_new_rounded),
                                    ),
                                    Text('$_pageNumber',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                    IconButton(
                                      onPressed: _pageNumber < _totalPages
                                          ? () {
                                              setState(() {
                                                _pageNumber = _pageNumber + 1;
                                              });
                                              _fetchUsers();
                                            }
                                          : null,
                                      icon: const Icon(
                                          Icons.arrow_forward_ios_rounded),
                                    ),
                                  ],
                                ),
                              ]
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
              DataColumn(label: Text('Role')),
              DataColumn(label: Text('Active')),
              DataColumn(label: Text('Manage')),
              DataColumn(label: Text('Message')),
            ],
            rows: _users.map<DataRow>((user) {
              return DataRow(cells: [
                DataCell(Text('${user.username} (${user.name} ${user.surname})',
                    style: TextStyle(fontSize: 12))),
                DataCell(Text(user.email, style: TextStyle(fontSize: 12))),
                DataCell(
                  Text(
                      user.role == "carrepairshop"
                          ? "Car Repair Shop"
                          : user.role == "carpartsshop"
                              ? "Car Parts Shop"
                              : "Client",
                      style: TextStyle(fontSize: 12)),
                ),
                DataCell(Text(user.active ? 'Yes' : 'No',
                    style: TextStyle(fontSize: 12))),
                DataCell(
                  ElevatedButton(
                    onPressed: () =>
                        _changeActiveStatus(user.id, user.username),
                    child: Text(user.active ? 'Deactivate' : 'Activate',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      UserMinimal userMinimal = UserMinimal(user.id,
                          user.username, user.name, user.surname, user.image);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(recipient: userMinimal),
                        ),
                      );
                    },
                    child:
                        const Text('Message', style: TextStyle(fontSize: 12)),
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
