import 'package:fixmycar_client/src/models/car_manufacturer/car_manufacturer.dart';
import 'package:fixmycar_client/src/models/car_model/car_model.dart';
import 'package:fixmycar_client/src/models/car_model/car_models_by_manufacturer.dart';
import 'package:fixmycar_client/src/models/car_repair_shop_discount/car_repair_shop_discount.dart';
import 'package:fixmycar_client/src/models/car_repair_shop_service/car_repair_shop_service.dart';
import 'package:fixmycar_client/src/models/car_repair_shop_service/car_repair_shop_service_search_object.dart';
import 'package:fixmycar_client/src/models/date_availability/date_availability.dart';
import 'package:fixmycar_client/src/models/reservation/reservation_insert_update.dart';
import 'package:fixmycar_client/src/models/user/user.dart';
import 'package:fixmycar_client/src/providers/car_models_by_manufacturer_provider.dart';
import 'package:fixmycar_client/src/providers/car_repair_shop_discount_provider.dart';
import 'package:fixmycar_client/src/providers/services_recommender_provider.dart';
import 'package:fixmycar_client/src/screens/reservation_history_screen.dart';
import 'package:fixmycar_client/src/widgets/shop_details_widget.dart';
import 'package:fixmycar_client/src/providers/car_repair_shop_services_provider.dart';
import 'package:fixmycar_client/src/providers/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
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
  int _pageNumber = 1;
  final int _pageSize = 10;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();

    carRepairShopFilter = widget.carRepairShop.username;
    carRepairShopId = widget.carRepairShop.id;
    carRepairShopDetails = widget.carRepairShop;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<CarRepairShopServiceProvider>(context, listen: false)
          .getByCarRepairShop(
              carRepairShopName: carRepairShopFilter,
              pageNumber: _pageNumber,
              pageSize: _pageSize);

      await _fetchDiscounts();
      await _fetchCarModels();
      await _fetchAvailability();
    });
  }

  String _selectedDiscountFilter = 'all';
  String _selectedTypeFilter = 'all';
  String _filterName = '';
  bool _isFilterApplied = false;
  bool clientOrder = false;
  bool isOrderWithRepairs = false;
  List<CarRepairShopDiscount> _discounts = [];

  List<CarModelsByManufacturer> _carModelsByManufacturer = [];
  late List<CarRepairShopService> recommendedServices;
  CarManufacturer? _selectedManufacturer;
  CarModel? _selectedModel;

  TextEditingController _nameFilterController = TextEditingController();
  TextEditingController _orderIdContoller = TextEditingController();

  Map<DateTime, Duration> _availabileDays = {};
  late final List<int> _workingDays =
      parseWorkDays(carRepairShopDetails.workDays!);
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<int> selectedServiceIds = [];
  Duration _totalServicesDuration = Duration();
  late final Duration _totalEffectiveWorkTime =
      _calculateTotalEffectiveWorkTime(
          carRepairShopDetails.workingHours, carRepairShopDetails.employees);

  Duration _calculateTotalEffectiveWorkTime(
      String? workingHours, int? employees) {
    if (workingHours == null || employees == null || employees <= 0) {
      return Duration.zero;
    }

    List<String> parts = workingHours.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    Duration totalWorkingTime =
        Duration(hours: hours, minutes: minutes, seconds: seconds);

    Duration bufferTimePerEmployee = Duration(hours: 1, minutes: 30);

    Duration totalBufferTime = bufferTimePerEmployee * employees;

    Duration totalEffectiveWorkTime =
        (totalWorkingTime * employees) - totalBufferTime;

    if (totalEffectiveWorkTime.isNegative) {
      totalEffectiveWorkTime = Duration.zero;
    }

    return totalEffectiveWorkTime;
  }

  bool _isDayEnabled(DateTime day) {
    bool isWorkingDay = _workingDays.contains(day.weekday);

    if (!isWorkingDay) {
      return false;
    }

    DateTime selectedDay = DateTime(day.year, day.month, day.day);

    for (DateTime availableDay in _availabileDays.keys) {
      DateTime availableDate =
          DateTime(availableDay.year, availableDay.month, availableDay.day);

      if (selectedDay == availableDate) {
        return _availabileDays[availableDay]! >= _totalServicesDuration;
      }
    }

    return true;
  }

  Future<void> _fetchCarModels() async {
    final carModelsByManufacturerProvider =
        Provider.of<CarModelsByManufacturerProvider>(context, listen: false);
    await carModelsByManufacturerProvider.getCarModelsByManufacturer();
    setState(() {
      _carModelsByManufacturer =
          carModelsByManufacturerProvider.modelsByManufacturer;
    });
  }

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

  Future<void> _fetchAvailability() async {
    final reservationProvider =
        Provider.of<ReservationProvider>(context, listen: false);
    List<DateAvailability> availableDays =
        await reservationProvider.getAvailability(shopId: carRepairShopId);

    setState(() {
      _availabileDays = {
        for (var day in availableDays)
          DateTime.parse(day.date): _parseDuration(day.freeHours)
      };
    });
  }

  Duration _parseDuration(String durationStr) {
    List<String> parts = durationStr.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }

  void _showCalendarDialog(
      BuildContext context, Function(DateTime) onDaySelected) {
    CalendarFormat _calendarFormat = CalendarFormat.month;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('Select Reservation Day'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: TableCalendar(
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Format',
                    CalendarFormat.twoWeeks: 'Format',
                    CalendarFormat.week: 'Format',
                  },
                  onFormatChanged: (format) {
                    setDialogState(() {
                      _calendarFormat = format;
                    });
                  },
                  calendarFormat: _calendarFormat,
                  focusedDay: _focusedDay,
                  firstDay: DateTime.now(),
                  lastDay: DateTime(DateTime.now().year + 1),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (_isDayEnabled(selectedDay)) {
                      setDialogState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });

                      onDaySelected(selectedDay);

                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  enabledDayPredicate: _isDayEnabled,
                  calendarStyle: CalendarStyle(
                    todayDecoration: const BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
                    selectedDecoration: const BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                    disabledTextStyle: TextStyle(color: Colors.grey.shade800),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      },
    );
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
          return "€${discountedTotal.toStringAsFixed(2)}";
        } else {
          return "€${totalAmount.toStringAsFixed(2)}";
        }
      } else {
        return "€${totalAmount.toStringAsFixed(2)}";
      }
    } else {
      return "Unknown";
    }
  }

  String _parseTimeOfDay(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')} hours, ${minutes.toString().padLeft(2, '0')} minutes';
  }

  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _openShoppingCartForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    bool isCardValid = false;
    bool cardError = false;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                right: 10,
                left: 10,
                top: 10,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Your Services',
                            style: TextStyle(fontSize: 24)),
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
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Total amount: ${_loadTotalAmount()}"),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                              "Estimated duration: ${_parseTimeOfDay(_totalServicesDuration)}"),
                        ],
                        const SizedBox(height: 16.0),
                        FocusScope(
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                Scrollable.ensureVisible(
                                  context,
                                  duration: const Duration(milliseconds: 300),
                                  alignment: 1.0, // Align to bottom
                                );
                              }
                            },
                            child: stripe.CardField(
                              onCardChanged: (card) {
                                setState(() {
                                  isCardValid = card!.complete;
                                  if (card.complete) {
                                    cardError = false;
                                  }
                                });
                                setModalState(() {
                                  isCardValid = card!.complete;
                                  if (card.complete) {
                                    cardError = false;
                                  }
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        if (!isCardValid && cardError) ...[
                          const SizedBox(height: 5.0),
                          Text(
                            "Please insert card details",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
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
                                  setModalState(() {
                                    clientOrder = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (clientOrder) ...[
                            TextFormField(
                              controller: _orderIdContoller,
                              decoration: const InputDecoration(
                                  labelText: 'Order Number'),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null;
                                } else {
                                  final orderId = int.tryParse(value.trim());
                                  if (orderId == null) {
                                    return "Please enter a valid order number (numeric)";
                                  } else {
                                    return null;
                                  }
                                }
                              },
                            ),
                            const Text('You can add order number later')
                          ],
                        ],
                        const SizedBox(height: 5.0),
                        DropdownButtonFormField<CarManufacturer>(
                          value: _selectedManufacturer,
                          validator: (value) {
                            if (value == null) {
                              return "Select car manufacturer";
                            }
                            return null;
                          },
                          onChanged: (CarManufacturer? newValue) {
                            setState(() {
                              _selectedManufacturer = newValue;
                              _selectedModel = null;
                            });
                            setModalState(() {
                              _selectedManufacturer = newValue;
                              _selectedModel = null;
                            });
                          },
                          items: _carModelsByManufacturer
                              .map<DropdownMenuItem<CarManufacturer>>(
                                  (CarModelsByManufacturer cm) {
                            return DropdownMenuItem<CarManufacturer>(
                              value: cm.manufacturer,
                              child: Text(cm.manufacturer.name),
                            );
                          }).toList(),
                          isExpanded: true,
                          hint: const Text('Select a manufacturer'),
                        ),
                        if (_selectedManufacturer != null) ...[
                          const SizedBox(height: 5.0),
                          DropdownButtonFormField<CarModel>(
                            value: _selectedModel,
                            validator: (value) {
                              if (value == null) {
                                return "Select car model";
                              }
                              return null;
                            },
                            onChanged: (CarModel? newValue) {
                              setState(() {
                                if (newValue != null) {
                                  _selectedModel = newValue;
                                }
                              });
                              setModalState(() {
                                if (newValue != null) {
                                  _selectedModel = newValue;
                                }
                              });
                            },
                            items: _carModelsByManufacturer
                                .firstWhere((cm) =>
                                    cm.manufacturer == _selectedManufacturer!)
                                .models
                                .map<DropdownMenuItem<CarModel>>(
                                    (CarModel model) {
                              return DropdownMenuItem<CarModel>(
                                value: model,
                                child:
                                    Text('${model.name} (${model.modelYear})'),
                              );
                            }).toList(),
                            isExpanded: true,
                            hint: const Text('Select a model'),
                          ),
                        ],
                        const SizedBox(height: 5.0),
                        ElevatedButton(
                          onPressed: () {
                            _showCalendarDialog(
                              context,
                              (DateTime selectedDay) {
                                setModalState(() {
                                  _selectedDay = selectedDay;
                                });
                              },
                            );
                          },
                          child: const Text('Select Reservation Date'),
                        ),
                        Text(
                            "Reservation date: ${_selectedDay != null ? "${_formatDate(_selectedDay.toString())}." : 'Select reservation date to continue'}"),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(18, 255, 255, 255),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(18, 255, 255, 255),
                              ),
                              onPressed: () => _confirmDiscard(context),
                              child: const Text('Discard'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(18, 255, 255, 255),
                              ),
                              onPressed: selectedServiceIds.isNotEmpty &&
                                      _selectedDay != null
                                  ? () {
                                      if ((formKey.currentState?.validate() ??
                                          false)) {
                                        if (isCardValid) {
                                          _confirmPlaceReservation(context);
                                        } else {
                                          setModalState(() {
                                            cardError = true;
                                          });
                                        }
                                      }
                                    }
                                  : null,
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
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
                  _selectedDay = null;
                  selectedServiceIds.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Discard successful!"),
                  ),
                );
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

  String _formatTimeOfDayCustom(TimeOfDay timeOfDay) {
    final String hours = timeOfDay.hour.toString().padLeft(2, '0');
    final String minutes = timeOfDay.minute.toString().padLeft(2, '0');

    return "$hours:$minutes";
  }

  Future<void> _confirmPlaceReservation(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Place Reservation'),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Are you sure you want to place this reservation?'),
                const SizedBox(
                  height: 10,
                ),
                Text(
                    'Note: Please make sure to bring your vehicle for an appointment on ${_formatDate(_selectedDay.toString())}. at ${_formatTimeOfDayCustom(_parseTime(carRepairShopDetails.openingTime!))}.'),
              ]),
          actions: [
            TextButton(
              onPressed: () async {
                ReservationInsertUpdate newReservation;
                if (clientOrder && isOrderWithRepairs) {
                  int? orderId;
                  orderId = int.tryParse(_orderIdContoller.text);
                  newReservation = ReservationInsertUpdate(
                      carRepairShopId,
                      _selectedModel!.id,
                      orderId,
                      clientOrder,
                      _selectedDay,
                      selectedServiceIds);
                } else {
                  newReservation = ReservationInsertUpdate(
                      carRepairShopId,
                      _selectedModel!.id,
                      null,
                      clientOrder,
                      _selectedDay,
                      selectedServiceIds);
                }
                try {
                  await Provider.of<ReservationProvider>(context, listen: false)
                      .insertReservation(newReservation)
                      .then((_) {
                    setState(() {
                      selectedServiceIds.clear();
                      _orderIdContoller.clear();
                      _selectedDay = null;
                      _selectedManufacturer = null;
                      _selectedModel = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Reservation successful!"),
                      ),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReservationHistoryScreen(),
                      ),
                    );
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
                      '€${service.price.toStringAsFixed(2)}', dialogContext),
                  if (service.discount != 0)
                    _buildDetailRow(
                        'Discount',
                        '${(service.discount * 100).toStringAsFixed(2)}%',
                        dialogContext),
                  if (service.discount != 0)
                    _buildDetailRow(
                      'Discounted Price',
                      '€${service.discountedPrice.toStringAsFixed(2)}',
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
                    'Estimated Duration',
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
            if (!provider.isLoading) {
              _totalPages = (provider.countOfItems / _pageSize).ceil();
            }
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
                          : 'No services available.'),
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
                                          text:
                                              '€${service.price.toStringAsFixed(2)} ',
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.red,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' €${service.discountedPrice.toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ] else ...[
                                        TextSpan(
                                          text:
                                              '${service.price.toStringAsFixed(2)}€',
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
                                            Duration tempTotalServicesDuration =
                                                _totalServicesDuration +
                                                    _parseDuration(
                                                        service.duration);
                                            if (tempTotalServicesDuration >
                                                _totalEffectiveWorkTime) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Adding this service exceeds shop working time!"),
                                                ),
                                              );
                                            } else {
                                              selectedServiceIds
                                                  .add(service.id);
                                              _totalServicesDuration +=
                                                  _parseDuration(
                                                      service.duration);
                                            }
                                          } else {
                                            selectedServiceIds
                                                .remove(service.id);
                                            _totalServicesDuration -=
                                                _parseDuration(
                                                    service.duration);
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
                if (provider.services.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _pageNumber > 1
                            ? () {
                                setState(() {
                                  _pageNumber = _pageNumber - 1;
                                  _applyFilters();
                                });
                              }
                            : null,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      Text('$_pageNumber',
                          style: Theme.of(context).textTheme.bodyLarge),
                      IconButton(
                        onPressed: _pageNumber < _totalPages
                            ? () {
                                setState(() {
                                  _pageNumber = _pageNumber + 1;
                                });
                                _applyFilters();
                              }
                            : null,
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                ],
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
        carRepairShopName: carRepairShopFilter,
        serviceSearch: search,
        pageNumber: _pageNumber,
        pageSize: _pageSize);
  }

  @override
  void dispose() {
    _nameFilterController.dispose();
    super.dispose();
  }
}
