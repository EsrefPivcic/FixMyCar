import 'package:fixmycar_client/src/models/car_repair_shop_discount/car_repair_shop_discount.dart';
import 'package:fixmycar_client/src/models/car_repair_shop_service/car_repair_shop_service.dart';
import 'package:fixmycar_client/src/models/car_repair_shop_service/car_repair_shop_service_search_object.dart';
import 'package:fixmycar_client/src/models/reservation/reservation_insert_update.dart';
import 'package:fixmycar_client/src/models/user/user.dart';
import 'package:fixmycar_client/src/providers/car_repair_shop_discount_provider.dart';
import 'package:fixmycar_client/src/providers/services_recommender_provider.dart';
import 'package:fixmycar_client/src/screens/reservation_history_screen.dart';
import 'package:fixmycar_client/src/widgets/shop_details_widget.dart';
import 'package:fixmycar_client/src/providers/car_repair_shop_services_provider.dart';
import 'package:fixmycar_client/src/providers/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'master_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

class CarRepairShopServicesScreen extends StatefulWidget {
  final User carRepairShop;

  const CarRepairShopServicesScreen({super.key, required this.carRepairShop});

  @override
  _CarRepairShopServicesScreenState createState() =>
      _CarRepairShopServicesScreenState();
}

class _CarRepairShopServicesScreenState
    extends State<CarRepairShopServicesScreen> {
  late String carRepairShopFilter;
  late int carRepairShopId;
  late List<CarRepairShopService> loadedServices;
  late User carRepairShopDetails;

  @override
  void initState() {
    super.initState();

    carRepairShopFilter = widget.carRepairShop.username;
    carRepairShopId = widget.carRepairShop.id;
    carRepairShopDetails = widget.carRepairShop;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<CarRepairShopServiceProvider>(context, listen: false)
          .getByCarRepairShop(carRepairShopName: carRepairShopFilter);

      await _fetchDiscounts();
    });
  }

  List<int> selectedServiceIds = [];

  String _selectedDiscountFilter = 'all';
  String _selectedTypeFilter = 'all';
  String _filterName = '';
  bool _isFilterApplied = false;
  bool clientOrder = false;
  bool isOrderWithRepairs = false;
  DateTime? reservationDate;
  List<CarRepairShopDiscount> _discounts = [];
  late List<CarRepairShopService> recommendedServices;

  TextEditingController _nameFilterController = TextEditingController();
  TextEditingController _orderIdContoller = TextEditingController();

  void _checkForTypes() {
    setState(() {
      isOrderWithRepairs = false;
    });
    if (selectedServiceIds.isNotEmpty) {
      for (var serviceId in selectedServiceIds) {
        final service = loadedServices.firstWhere((s) => s.id == serviceId);
        if (service.serviceTypeName == "Repairs") {
          setState(() {
            isOrderWithRepairs = true;
          });
        }
      }
    }
  }

  Future<void> _fetchDiscounts() async {
    final discountProvider =
        Provider.of<CarRepairShopDiscountProvider>(context, listen: false);
    await discountProvider.getByClient(carRepairShop: carRepairShopFilter);
    setState(() {
      _discounts = discountProvider.discounts;
    });
  }

  String _formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  String _loadTotalAmount() {
    if (selectedServiceIds.isNotEmpty) {
      double totalAmount = 0;
      for (var selectedServiceId in selectedServiceIds) {
        CarRepairShopService serviceDetails = loadedServices.firstWhere(
            (loadedService) => loadedService.id == selectedServiceId);
        totalAmount = totalAmount + serviceDetails.discountedPrice;
      }
      if (_discounts.isNotEmpty) {
        double discountValue = 0;
        for (var discount in _discounts) {
          if (discount.revoked == null) {
            discountValue = discount.value;
          }
        }
        if (discountValue != 0) {
          double discountedTotal = totalAmount - (totalAmount * discountValue);
          return "$discountedTotal€";
        } else {
          return "$totalAmount€";
        }
      } else {
        return "$totalAmount€";
      }
    } else {
      return "Unknown";
    }
  }

  void _openShoppingCartForm(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Your Services', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 16.0),
                    if (selectedServiceIds.isEmpty) ...[
                      const Text('No items in your cart.')
                    ] else ...[
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: selectedServiceIds.length,
                          itemBuilder: (context, index) {
                            final serviceId = selectedServiceIds[index];
                            final service = loadedServices
                                .firstWhere((s) => s.id == serviceId);
                            return ListTile(
                              leading: service.imageData != ""
                                  ? Image.memory(
                                      base64Decode(service.imageData!),
                                      fit: BoxFit.contain,
                                      width: 50,
                                      height: 50,
                                    )
                                  : const Icon(Icons.image, size: 50),
                              title: Text(service.name),
                              subtitle: Text(service.serviceTypeName),
                            );
                          },
                        ),
                      ),
                      Text("Total amount: ${_loadTotalAmount()}"),
                    ],
                    const SizedBox(height: 16.0),
                    if (isOrderWithRepairs) ...[
                      Row(
                        children: [
                          const Text('Car parts ordered by me:'),
                          Switch(
                            value: clientOrder,
                            onChanged: (bool value) {
                              setState(() {
                                clientOrder = value;
                              });
                            },
                          ),
                        ],
                      ),
                      if (clientOrder) ...[
                        TextField(
                          controller: _orderIdContoller,
                          decoration:
                              const InputDecoration(labelText: 'Order Number'),
                        ),
                        const Text('You can add order number later')
                      ],
                    ],
                    const SizedBox(height: 5.0),
                    ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_month),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(18, 255, 255, 255),
                        ),
                        onPressed: () async {
                          final selectedReservationDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.now().add(const Duration(days: 1)),
                              firstDate:
                                  DateTime.now().add(const Duration(days: 1)),
                              lastDate: DateTime(2100),
                              helpText: "Reservation date");

                          if (selectedReservationDate != null) {
                            setState(() {
                              reservationDate = selectedReservationDate;
                            });
                          }
                        },
                        label: const Text("Select reservation date")),
                    Text(
                        "Reservation date: ${reservationDate != null ? _formatDate(reservationDate.toString()) : 'not selected'}"),
                    const SizedBox(height: 16.0),
                    stripe.CardField(
                      onCardChanged: (card) {
                        print(card);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(18, 255, 255, 255),
                          ),
                          onPressed: selectedServiceIds.isNotEmpty &&
                                  reservationDate != null
                              ? () {
                                  _confirmPlaceReservation(context);
                                }
                              : null,
                          child: const Text('Place Reservation'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(18, 255, 255, 255),
                          ),
                          onPressed: () => _confirmDiscard(context),
                          child: const Text('Discard Reservation'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(18, 255, 255, 255),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void _confirmDiscard(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Discard Order'),
          content: const Text('Are you sure you want to discard the order?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  clientOrder = false;
                  reservationDate = null;
                  selectedServiceIds.clear();
                });
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmPlaceReservation(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Place Reservation'),
          content:
              const Text('Are you sure you want to place this reservation?'),
          actions: [
            TextButton(
              onPressed: () async {
                bool validateOrder = false;
                bool validateDate = false;
                ReservationInsertUpdate newReservation;

                if (reservationDate != null) {
                  validateDate = true;
                } else {
                  validateDate = false;
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please provide a valid reservation date!"),
                    ),
                  );
                }
                if (clientOrder && isOrderWithRepairs) {
                  int? orderId;
                  if (_orderIdContoller.text.isNotEmpty) {
                    orderId = int.tryParse(_orderIdContoller.text);
                    if (orderId == null) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      validateOrder = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please provide a valid order number!"),
                        ),
                      );
                    } else {
                      validateOrder = true;
                    }
                  } else {
                    validateOrder = true;
                  }
                  newReservation = ReservationInsertUpdate(
                      carRepairShopId,
                      orderId,
                      clientOrder,
                      reservationDate,
                      selectedServiceIds);
                } else {
                  validateOrder = true;
                  newReservation = ReservationInsertUpdate(carRepairShopId,
                      null, clientOrder, reservationDate, selectedServiceIds);
                }
                if (validateDate && validateOrder) {
                  try {
                    await Provider.of<ReservationProvider>(context,
                            listen: false)
                        .insertReservation(newReservation)
                        .then((_) {
                      setState(() {
                        selectedServiceIds.clear();
                        _orderIdContoller.clear();
                        reservationDate = null;
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ReservationHistoryScreen(),
                          ),
                        );
                      });
                    });
                  } catch (e) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                }
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _showDetailsDialog(
      BuildContext context, CarRepairShopService service) async {
    final recommenderProvider =
        Provider.of<ServicesRecommenderProvider>(context, listen: false);

    await recommenderProvider.getServicesRecommendations(
        carRepairShopServiceId: service.id);
    recommendedServices = recommenderProvider.recommendedServices;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            service.name,
            style: Theme.of(dialogContext).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: double.infinity),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (service.imageData != null &&
                      service.imageData!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(
                          base64Decode(service.imageData!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  _buildDetailRow('Price',
                      '${service.price.toStringAsFixed(2)}€', dialogContext),
                  if (service.discount != 0)
                    _buildDetailRow('Discount',
                        '${(service.discount * 100).toInt()}%', dialogContext),
                  if (service.discount != 0)
                    _buildDetailRow(
                      'Discounted Price',
                      '${service.discountedPrice.toStringAsFixed(2)}€',
                      dialogContext,
                    ),
                  _buildDetailRow(
                      'Type', service.serviceTypeName, dialogContext),
                  _buildDetailRow(
                    'Details',
                    service.details ?? "No details available",
                    dialogContext,
                  ),
                  _buildDetailRow(
                    'Duration',
                    service.duration,
                    dialogContext,
                  ),
                  if (recommenderProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (recommenderProvider.recommendedServices.isEmpty)
                    const Center(child: Text('No recommendations.'))
                  else ...[
                    const SizedBox(height: 10),
                    Text("Along ${service.name}, users usually appoint:"),
                    const SizedBox(height: 5),
                    Column(
                      children:
                          List.generate(recommendedServices.length, (index) {
                        final recommendedService = recommendedServices[index];
                        return ListTile(
                          onTap: () async {
                            Navigator.of(dialogContext).pop();
                            await Future.delayed(
                                const Duration(milliseconds: 150));
                            _showDetailsDialog(context, recommendedService);
                          },
                          leading: recommendedService.imageData != ""
                              ? Image.memory(
                                  base64Decode(recommendedService.imageData!),
                                  fit: BoxFit.contain,
                                  width: 50,
                                  height: 50,
                                )
                              : const Icon(Icons.image, size: 50),
                          title: Text(recommendedService.name),
                        );
                      }),
                    ),
                  ]
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$title:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: MasterScreen(
        child: Consumer<CarRepairShopServiceProvider>(
          builder: (context, provider, child) {
            loadedServices = provider.services;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 8.0, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.filter_list),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(18, 255, 255, 255)),
                        onPressed: () {
                          _showFilterDialog(context);
                        },
                        label: const Text("Filters"),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.info_outline_rounded),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(18, 255, 255, 255)),
                        onPressed: () {
                          showShopDetailsDialog(
                              context, carRepairShopDetails, _discounts, null);
                        },
                        label: const Text("Shop details"),
                      ),
                    ],
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
                          : 'No items available.'),
                    ),
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isPortrait ? 2 : 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: provider.services.length,
                      itemBuilder: (context, index) {
                        final CarRepairShopService service =
                            provider.services[index];
                        final bool isSelected =
                            selectedServiceIds.contains(service.id);
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
                                            width: 125,
                                            height: 125,
                                          )
                                        : const SizedBox(
                                            width: 150,
                                            height: 150,
                                            child: Icon(Icons.image, size: 100),
                                          ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  service.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
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
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  service.serviceTypeName == ""
                                      ? "Unknown"
                                      : service.serviceTypeName,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).highlightColor,
                                      ),
                                      onPressed: () {
                                        _showDetailsDialog(context, service);
                                      },
                                      child: const Text('Details'),
                                    ),
                                    Checkbox(
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            selectedServiceIds.add(service.id);
                                          } else {
                                            selectedServiceIds
                                                .remove(service.id);
                                          }
                                        });
                                        _checkForTypes();
                                      },
                                    ),
                                  ],
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
          _openShoppingCartForm(context);
        },
        backgroundColor: Theme.of(context).hoverColor,
        child: const Icon(Icons.car_repair, color: Colors.white),
      ),
    );
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
    String? typeFilter;
    bool? discountFilter;

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
        discountFilter);

    provider.getByCarRepairShop(
        carRepairShopName: carRepairShopFilter, serviceSearch: search);
  }

  @override
  void dispose() {
    _nameFilterController.dispose();
    super.dispose();
  }
}
