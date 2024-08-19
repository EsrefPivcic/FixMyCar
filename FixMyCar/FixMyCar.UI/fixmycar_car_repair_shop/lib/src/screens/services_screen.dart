import 'package:fixmycar_car_repair_shop/src/models/car_repair_shop_service/car_repair_shop_service.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_repair_shop_service/car_repair_shop_service_search_object.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_repair_shop_service_provider.dart';
import 'package:fixmycar_car_repair_shop/src/models/service_type/service_type.dart';
import 'package:fixmycar_car_repair_shop/src/providers/service_type_provider.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_repair_shop_service/car_repair_shop_service_insert_update.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _filterName = '';
  TextEditingController _nameFilterController = TextEditingController();
  String _selectedStatusFilter = 'all';
  String _selectedDiscountFilter = 'all';
  String _selectedTypeFilter = 'all';
  bool _isFilterApplied = false;
  List<ServiceType> _serviceTypes = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<CarRepairShopServiceProvider>(context, listen: false)
          .getByCarRepairShop();
      await _fetchServiceTypes();
    });
  }

  Future<void> _fetchServiceTypes() async {
    final serviceTypesProvider =
        Provider.of<ServiceTypeProvider>(context, listen: false);
    await serviceTypesProvider.getTypes();
    setState(() {
      _serviceTypes = serviceTypesProvider.types;
    });
  }

  void _showFilterDialog(BuildContext context) {
    _nameFilterController.text = _filterName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Filters'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter by Name'),
                    TextField(
                      decoration: const InputDecoration(hintText: 'Enter name'),
                      controller: _nameFilterController,
                      onChanged: (value) {
                        setState(() {
                          _filterName = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('StoreItem Status'),
                    RadioListTile<String>(
                      title: const Text('Active'),
                      value: 'active',
                      groupValue: _selectedStatusFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatusFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Hidden'),
                      value: 'draft',
                      groupValue: _selectedStatusFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatusFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('All'),
                      value: 'all',
                      groupValue: _selectedStatusFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatusFilter = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Discount Status'),
                    RadioListTile<String>(
                      title: const Text('Discounted'),
                      value: 'discounted',
                      groupValue: _selectedDiscountFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedDiscountFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Non-Discounted'),
                      value: 'non-discounted',
                      groupValue: _selectedDiscountFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedDiscountFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('All'),
                      value: 'all',
                      groupValue: _selectedDiscountFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedDiscountFilter = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Service Type'),
                    RadioListTile<String>(
                      title: const Text('Diagnostics'),
                      value: 'Diagnostics',
                      groupValue: _selectedTypeFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedTypeFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Repairs'),
                      value: 'Repairs',
                      groupValue: _selectedTypeFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedTypeFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('All'),
                      value: 'all',
                      groupValue: _selectedTypeFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedTypeFilter = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Apply Filters'),
                  onPressed: () {
                    _applyFilters();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _applyFilters() {
    final provider =
        Provider.of<CarRepairShopServiceProvider>(context, listen: false);
    String? stateFilter;
    String? typeFilter;
    bool? discountFilter;

    if (_selectedStatusFilter != 'all') {
      stateFilter = _selectedStatusFilter;
    }
    if (_selectedTypeFilter != 'all') {
      typeFilter = _selectedTypeFilter;
    }
    if (_selectedDiscountFilter == 'discounted') {
      discountFilter = true;
    } else if (_selectedDiscountFilter == 'non-discounted') {
      discountFilter = false;
    }

    setState(() {
      _isFilterApplied = true;
    });

    CarRepairShopServiceSearchObject search = CarRepairShopServiceSearchObject(
        typeFilter,
        _filterName.isNotEmpty ? _filterName : null,
        discountFilter,
        stateFilter);

    provider.getByCarRepairShop(serviceSearch: search);
  }

  void _showEditForm(
      BuildContext context, CarRepairShopService? service, bool edit) {
    TextEditingController nameController = TextEditingController(text: "");
    TextEditingController discountController = TextEditingController(text: "");
    TextEditingController priceController = TextEditingController(text: "0");
    TextEditingController detailsController = TextEditingController(text: "");
    String? base64Image = "";
    String? imagePath;
    int? serviceTypeId;
    ServiceType? selectedServiceType;
    Duration selectedDuration = Duration();
    CarRepairShopServiceInsertUpdate newService =
        CarRepairShopServiceInsertUpdate.n();

    if (edit) {
      nameController = TextEditingController(text: service!.name);
      discountController =
          TextEditingController(text: (service.discount * 100).toString());
      priceController = TextEditingController(text: service.price.toString());
      detailsController = TextEditingController(text: service.details);
      base64Image = service.imageData;
      serviceTypeId = service.serviceTypeId;
      selectedServiceType =
          _serviceTypes.firstWhere((type) => type.id == service.serviceTypeId);
      selectedDuration = _parseDuration(service.duration);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<ServiceType>(
                        value: selectedServiceType,
                        onChanged: (ServiceType? newValue) {
                          setState(() {
                            selectedServiceType = newValue;
                            serviceTypeId = newValue?.id;
                            newService.serviceTypeId = serviceTypeId;
                          });
                        },
                        items: _serviceTypes.map<DropdownMenuItem<ServiceType>>(
                            (ServiceType type) {
                          return DropdownMenuItem<ServiceType>(
                            value: type,
                            child: Text(type.name),
                          );
                        }).toList(),
                        isExpanded: true,
                        hint: const Text('Select a service type'),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Service Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price (€)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: discountController,
                        decoration: const InputDecoration(
                          labelText: 'Discount (%)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                DateTime(0).add(selectedDuration)),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedDuration = Duration(
                                  hours: pickedTime.hour,
                                  minutes: pickedTime.minute);
                            });
                          }
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.outline),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Duration'),
                                Text(
                                    '${selectedDuration.inHours.toString().padLeft(2, '0')}:${(selectedDuration.inMinutes % 60).toString().padLeft(2, '0')}:00'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: detailsController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Details',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (base64Image != "")
                        Image.memory(
                          base64Decode(base64Image!),
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                        )
                      else
                        const Icon(Icons.image, size: 150),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                          );
                          if (result != null) {
                            setState(() {
                              imagePath = result.files.single.path;
                              base64Image = base64Encode(
                                  File(imagePath!).readAsBytesSync());
                            });
                          }
                        },
                        child: const Text('Select Image'),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (edit) {
                                newService.name = nameController.text.isNotEmpty
                                    ? nameController.text
                                    : service!.name;
                                newService.price = priceController
                                        .text.isNotEmpty
                                    ? double.tryParse(priceController.text) ??
                                        service!.price
                                    : service!.price;
                                newService.discount =
                                    discountController.text.isNotEmpty
                                        ? double.tryParse(
                                                discountController.text)! /
                                            100
                                        : service!.discount;
                                newService.imageData = base64Image;
                                newService.details =
                                    detailsController.text.isNotEmpty
                                        ? detailsController.text
                                        : service!.details;
                                newService.duration =
                                    _durationToISO8601(selectedDuration);
                                newService.serviceTypeId =
                                    newService.serviceTypeId ??
                                        service!.serviceTypeId;
                                await Provider.of<CarRepairShopServiceProvider>(
                                        context,
                                        listen: false)
                                    .updateService(service!.id, newService)
                                    .then((_) {
                                  _applyFilters();
                                });
                                Navigator.of(context).pop();
                              } else {
                                if (nameController.text.isEmpty ||
                                    priceController.text.isEmpty ||
                                    selectedDuration.inMinutes == 0 ||
                                    serviceTypeId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Service name, price, duration and type are required!'),
                                    ),
                                  );
                                } else {
                                  newService.name = nameController.text;
                                  newService.price =
                                      double.tryParse(priceController.text) ??
                                          0;
                                  newService.discount =
                                      discountController.text.isNotEmpty
                                          ? double.tryParse(
                                                  discountController.text)! /
                                              100
                                          : null;
                                  newService.imageData = base64Image;
                                  newService.details = detailsController.text;
                                  newService.duration =
                                      _durationToISO8601(selectedDuration);
                                  newService.serviceTypeId = serviceTypeId;

                                  await Provider.of<
                                              CarRepairShopServiceProvider>(
                                          context,
                                          listen: false)
                                      .insertService(newService)
                                      .then((_) {
                                    Provider.of<CarRepairShopServiceProvider>(
                                            context,
                                            listen: false)
                                        .getByCarRepairShop();
                                  });
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
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

  Duration _parseDuration(String durationString) {
    final List<String> parts = durationString.split(':');
    if (parts.length == 3) {
      final int hours = int.tryParse(parts[0]) ?? 0;
      final int minutes = int.tryParse(parts[1]) ?? 0;
      return Duration(hours: hours, minutes: minutes);
    }
    return Duration();
  }

  String _durationToISO8601(Duration duration) {
    if (duration.inMinutes == 0) return 'PT0M';
    return 'PT${duration.inHours}H${duration.inMinutes % 60}M';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MasterScreen(
        child: Consumer<CarRepairShopServiceProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.filter_list,
                          color: Theme.of(context).primaryColorLight),
                      onPressed: () => _showFilterDialog(context),
                    ),
                  ),
                ),
                if (provider.isLoading)
                  const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                else if (provider.services.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(_isFilterApplied
                          ? 'No results found for your search.'
                          : 'No services available.'),
                    ),
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: provider.services.length,
                      itemBuilder: (context, index) {
                        final CarRepairShopService service =
                            provider.services[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: service.imageData != ""
                                        ? Image.memory(
                                            base64Decode(service.imageData!),
                                            fit: BoxFit.contain,
                                            width: 200,
                                            height: 200,
                                          )
                                        : const SizedBox(
                                            width: 200,
                                            height: 200,
                                            child: Icon(Icons.image, size: 150),
                                          ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  service.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      if (service.discount != 0) ...[
                                        TextSpan(
                                          text: '${service.price}€ ',
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.red,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' ${service.discountedPrice}€',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ] else ...[
                                        TextSpan(
                                          text: '${service.price}€',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ],
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (service.discount != 0)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Discount: ${(service.discount * 100).toInt()}%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Service Type: ${service.serviceTypeName}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Duration: ${service.duration}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: _buildActionButtons(service),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEditForm(context, null, false);
        },
        backgroundColor: Theme.of(context).hoverColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<Widget> _buildActionButtons(CarRepairShopService service) {
    if (service.state == 'draft') {
      return [
        ElevatedButton(
          onPressed: () {
            _showEditForm(context, service, true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
          child: const Text('Edit'),
        ),
        ElevatedButton(
          onPressed: () async {
            bool confirmDelete = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content:
                      const Text('Are you sure you want to delete this item?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            );
            if (confirmDelete) {
              await Provider.of<CarRepairShopServiceProvider>(context,
                      listen: false)
                  .deleteService(service.id)
                  .then((_) {
                _applyFilters();
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
          child: const Text('Delete'),
        ),
        ElevatedButton(
          onPressed: () async {
            bool confirmActivate = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Activation'),
                  content: const Text(
                      'Are you sure you want to activate this item?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            );
            if (confirmActivate) {
              await Provider.of<CarRepairShopServiceProvider>(context,
                      listen: false)
                  .activate(service.id)
                  .then((_) {
                _applyFilters();
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
          child: const Text('Activate'),
        ),
      ];
    } else {
      return [
        ElevatedButton(
          onPressed: () async {
            bool confirmHide = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Hiding'),
                  content:
                      const Text('Are you sure you want to hide this item?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            );
            if (confirmHide) {
              await Provider.of<CarRepairShopServiceProvider>(context,
                      listen: false)
                  .hide(service.id)
                  .then((_) {
                _applyFilters();
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
          child: const Text('Hide'),
        ),
      ];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
