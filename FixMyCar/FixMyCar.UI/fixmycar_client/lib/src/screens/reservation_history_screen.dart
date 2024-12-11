import 'package:fixmycar_client/src/models/date_availability/date_availability.dart';
import 'package:fixmycar_client/src/models/order/order_essential.dart';
import 'package:fixmycar_client/src/models/reservation/reservation.dart';
import 'package:fixmycar_client/src/models/reservation/reservation_insert_update.dart';
import 'package:fixmycar_client/src/models/reservation/reservation_search_object.dart';
import 'package:fixmycar_client/src/models/user/user.dart';
import 'package:fixmycar_client/src/providers/car_repair_shop_provider.dart';
import 'package:fixmycar_client/src/providers/order_essential_provider.dart';
import 'package:fixmycar_client/src/providers/reservation_detail_provider.dart';
import 'package:fixmycar_client/src/providers/reservation_provider.dart';
import 'package:fixmycar_client/src/screens/car_repair_shops_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'master_screen.dart';
import 'package:intl/intl.dart';

class ReservationHistoryScreen extends StatefulWidget {
  const ReservationHistoryScreen({Key? key}) : super(key: key);

  @override
  _ReservationHistoryScreenState createState() =>
      _ReservationHistoryScreenState();
}

ReservationSearchObject filterCriteria =
    ReservationSearchObject.n(minTotalAmount: 0, maxTotalAmount: 10000);
int _pageNumber = 1;
const int _pageSize = 10;
int _totalPages = 1;

class _ReservationHistoryScreenState extends State<ReservationHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ReservationProvider>(context, listen: false)
          .getByClient(
              reservationSearch: filterCriteria,
              pageNumber: _pageNumber,
              pageSize: _pageSize);
    });
  }

  Map<DateTime, Duration> _availabileDays = {};
  List<int> _workingDays = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Duration _totalServicesDuration = Duration();

  Duration _parseDuration(String durationStr) {
    List<String> parts = durationStr.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }

  Future<void> _fetchAvailability(int carRepairShopId) async {
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

  Future<void> _fetchWorkingDays(int carRepairShopId) async {
    final shopProvider =
        Provider.of<CarRepairShopProvider>(context, listen: false);
    User? shop;

    try {
      shop = await shopProvider.getShopById(shopId: carRepairShopId);
    } catch (e) {
      print(e.toString());
      shop = null;
    }

    if (shop != null) {
      setState(() {
        _workingDays = parseWorkDays(shop!.workDays!);
      });
    }
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

  void _showCalendarDialog(DateTime? orderDate, BuildContext context,
      Function(DateTime) onDaySelected) {
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
                  focusedDay: orderDate ?? _focusedDay,
                  firstDay: orderDate ?? DateTime.now(),
                  lastDay: DateTime(DateTime.now().year + 2),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (_isDayEnabled(selectedDay)) {
                      setDialogState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });

                      onDaySelected(selectedDay);
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

  Future showUpdateForm(Reservation reservation, DateTime? orderDate) async {
    _totalServicesDuration = _parseDuration(reservation.totalDuration);

    await _fetchAvailability(reservation.carRepairShopId);
    await _fetchWorkingDays(reservation.carRepairShopId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Reservation'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setUpdateDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showCalendarDialog(
                        orderDate,
                        context,
                        (DateTime selectedDay) {
                          setUpdateDialogState(() {
                            _selectedDay = selectedDay;
                          });
                        },
                      );
                    },
                    child: const Text('Select Reservation Date'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(_selectedDay != null
                      ? 'Reservation date: ${_formatDate(_selectedDay.toString())}'
                      : 'Please select new reservation date to continue.'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedDay = null;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: _selectedDay != null
                        ? () async {
                            ReservationInsertUpdate updateReservation =
                                ReservationInsertUpdate.n();
                            updateReservation.reservationDate = _selectedDay;
                            try {
                              await Provider.of<ReservationProvider>(context,
                                      listen: false)
                                  .updateReservation(
                                      reservation.id, updateReservation)
                                  .then((_) {
                                Provider.of<ReservationProvider>(context,
                                        listen: false)
                                    .getByClient(
                                        reservationSearch: filterCriteria,
                                        pageNumber: _pageNumber,
                                        pageSize: _pageSize);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Update successful!"),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            }
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String _formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  String _getOrderDisplayState(String state) {
    switch (state) {
      case "onhold":
        return "On hold";
      case "accepted":
        return "Accepted";
      case "rejected":
        return "Rejected";
      case "cancelled":
        return "Cancelled";
      case "missingpayment":
        return "Missing Payment";
      case "paymentfailed":
        return "Payment Failed";
      default:
        return state;
    }
  }

  Color _getOrderStateColor(String state) {
    switch (state) {
      case 'missingpayment':
        return Colors.red.shade400;
      case 'onhold':
        return Colors.blue.shade300;
      case 'accepted':
        return Colors.green.shade400;
      case 'rejected':
        return Colors.red.shade700;
      case 'paymentfailed':
        return Colors.red.shade700;
      case 'cancelled':
        return Colors.red.shade400;
      default:
        return Colors.white;
    }
  }

  String _getDisplayState(String state) {
    switch (state) {
      case "awaitingorder":
        return "Awaiting Order";
      case "orderpendingapproval":
        return "Order Pending Approval";
      case "orderdateconflict":
        return "Order Date Conflict (Update reservation date!)";
      case "ready":
        return "Ready";
      case "accepted":
        return "Accepted";
      case "ongoing":
        return "Ongoing";
      case "completed":
        return "Completed";
      case "rejected":
        return "Rejected";
      case "cancelled":
        return "Cancelled";
      case "missingpayment":
        return "Missing Payment";
      case "paymentfailed":
        return "Payment Failed";
      case "overbooked":
        return "Overbooked (Update reservation date!)";
      default:
        return state;
    }
  }

  Color _getStateColor(String state) {
    switch (state) {
      case 'missingpayment':
        return Colors.red.shade400;
      case 'awaitingorder':
        return Colors.yellow.shade200;
      case 'orderpendingapproval':
        return Colors.yellow.shade600;
      case 'orderdateconflict':
        return Colors.red.shade400;
      case 'ready':
        return Colors.blue.shade600;
      case 'accepted':
        return Colors.green.shade300;
      case 'ongoing':
        return Colors.orange.shade600;
      case 'completed':
        return Colors.green.shade600;
      case 'rejected':
        return Colors.red.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      case 'paymentfailed':
        return Colors.red.shade700;
      case 'overbooked':
        return Colors.red.shade700;
      default:
        return Colors.white;
    }
  }

  Future _confirmDelete(int reservationId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content:
            const Text('Are you sure you want to delete this reservation?'),
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
                await Provider.of<ReservationProvider>(context, listen: false)
                    .delete(reservationId)
                    .then((_) {
                  Provider.of<ReservationProvider>(context, listen: false)
                      .getByClient(
                          reservationSearch: filterCriteria,
                          pageNumber: _pageNumber,
                          pageSize: _pageSize);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Deleting reservation successful."),
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
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future _confirmCancel(int reservationId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Cancel'),
        content: const Text(
            'Are you sure you want to cancel this reservation? Full refund will be issued.'),
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
                await Provider.of<ReservationProvider>(context, listen: false)
                    .cancel(reservationId)
                    .then((_) {
                  Provider.of<ReservationProvider>(context, listen: false)
                      .getByClient(
                          reservationSearch: filterCriteria,
                          pageNumber: _pageNumber,
                          pageSize: _pageSize);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Cancelling reservation successful!"),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                  ),
                );
              }
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  final _orderController = TextEditingController();

  Future _addOrder(int reservationId) async {
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            title: const Text('Add Order'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _orderController,
                  decoration: const InputDecoration(labelText: 'Order number'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter an order number";
                    }
                    final orderId = int.tryParse(value.trim());
                    if (orderId == null) {
                      return "Please enter a valid order number (numeric)";
                    }
                    return null;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _orderController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if ((formKey.currentState?.validate() ?? false)) {
                    final orderIdText = _orderController.text;
                    final orderId = int.parse(orderIdText);

                    try {
                      await Provider.of<ReservationProvider>(context,
                              listen: false)
                          .addOrder(reservationId, orderId);
                      await Provider.of<ReservationProvider>(context,
                              listen: false)
                          .getByClient(
                              reservationSearch: filterCriteria,
                              pageNumber: _pageNumber,
                              pageSize: _pageSize);
                      _orderController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Adding order successful!"),
                        ),
                      );
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } catch (e) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Add Order'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showReservationDetails(
      BuildContext context, Reservation reservation) async {
    final reservationDetailProvider =
        Provider.of<ReservationDetailProvider>(context, listen: false);

    final orderProvider =
        Provider.of<OrderEssentialProvider>(context, listen: false);

    await reservationDetailProvider.getByReservation(id: reservation.id);

    OrderEssential? order;

    if (reservation.orderId != null) {
      await orderProvider.getOrderEssentialById(orderId: reservation.orderId!);
      final isOrderLoading = orderProvider.isLoading;
      if (isOrderLoading == false) {
        order = orderProvider.orderEssential;
      }
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final reservationDetails = reservationDetailProvider.reservationDetails;
        final isLoading = reservationDetailProvider.isLoading;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.90,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8.0),
                          const Text("Reservation details",
                              style: TextStyle(fontSize: 20)),
                          Card(
                            child: ListTile(
                              title: const Text('Car Repair Shop'),
                              subtitle: Text(reservation.carRepairShopName),
                            ),
                          ),
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: const Text('Reservation Created On'),
                                  subtitle: Text(_formatDate(
                                      reservation.reservationCreatedDate)),
                                ),
                                ListTile(
                                  title: const Text('Reservation Date'),
                                  subtitle: Text(
                                      _formatDate(reservation.reservationDate),
                                      style: TextStyle(
                                          color:
                                              reservation.state ==
                                                          "overbooked" ||
                                                      reservation.state ==
                                                          "orderdateconflict" ||
                                                      reservation.state ==
                                                          "cancelled" ||
                                                      reservation.state ==
                                                          "rejected" ||
                                                      reservation.state ==
                                                          "paymentfailed" ||
                                                      reservation.state ==
                                                          "missingpayment"
                                                  ? _getStateColor(
                                                      reservation.state)
                                                  : Colors.green.shade500)),
                                ),
                                ListTile(
                                  title:
                                      const Text('Estimated Completion Date'),
                                  subtitle: Text(
                                    reservation.estimatedCompletionDate == null
                                        ? "Not accepted"
                                        : _formatDate(reservation
                                            .estimatedCompletionDate!),
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Completion Date'),
                                  subtitle: Text(
                                    reservation.completionDate == null
                                        ? "Not completed"
                                        : _formatDate(
                                            reservation.completionDate!),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: const Text('Total Price'),
                                  subtitle: Text(
                                      '${reservation.totalAmount.toStringAsFixed(2)}€'),
                                ),
                                ListTile(
                                  title: const Text('Personal Discount'),
                                  subtitle: Text(
                                      '${(reservation.carRepairShopDiscountValue * 100).toStringAsFixed(2)}%'),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title:
                                      const Text('Estimated Services Duration'),
                                  subtitle: Text(reservation.totalDuration),
                                ),
                                ListTile(
                                  title: const Text('Car Model'),
                                  subtitle: Text(reservation.carModel),
                                ),
                                ListTile(
                                  title: const Text('Type'),
                                  subtitle: Text(reservation.type),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: const Text('State'),
                            subtitle: Text(
                              _getDisplayState(reservation.state),
                              style: TextStyle(
                                  color: _getStateColor(reservation.state)),
                            ),
                          ),
                          if (reservation.type != "Diagnostics") ...[
                            ListTile(
                              title: const Text('Parts order handled by'),
                              subtitle: Text(reservation.clientOrder == true
                                  ? "Me"
                                  : "Car Repair Shop"),
                            ),
                            if (order == null &&
                                reservation.clientOrder == true) ...[
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await _addOrder(reservation.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).hoverColor,
                                  ),
                                  child: const Text("Add Order"),
                                ),
                              ),
                            ],
                            if (order != null) ...[
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: ExpansionTile(
                                  title: Text(
                                      'Ordered from: ${order.carPartsShopName}'),
                                  subtitle: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(text: 'State: '),
                                        TextSpan(
                                          text: _getOrderDisplayState(
                                              order.state),
                                          style: TextStyle(
                                              color: _getOrderStateColor(
                                                  order.state)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Order date: ${_formatDate(order.orderDate)}',
                                              style: TextStyle(
                                                  color: reservation.state ==
                                                          "orderdateconflict"
                                                      ? _getStateColor(
                                                          reservation.state)
                                                      : Colors.green.shade500)),
                                          Text(
                                              'Shipping date: ${order.shippingDate != null ? _formatDate(order.shippingDate!) : 'Not accepted'}'),
                                          Text(
                                              'Items: ${order.items.join(', ')}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                          const SizedBox(height: 16.0),
                          Text(
                            'Services',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8.0),
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: reservationDetails.length,
                              itemBuilder: (context, index) {
                                final reservationDetail =
                                    reservationDetails[index];
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ExpansionTile(
                                    title: Text(reservationDetail.serviceName),
                                    subtitle: Text(
                                        'Price (Discount Applied): ${reservationDetail.serviceDiscountedPrice.toStringAsFixed(2)}€'),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Non-Discounted Price: ${reservationDetail.servicePrice.toStringAsFixed(2)}€'),
                                            Text(
                                                'Discount: ${(reservationDetail.serviceDiscount * 100).toStringAsFixed(2)}%'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (reservation.state == "awaitingorder" ||
                                  reservation.state == "ready" ||
                                  reservation.state == "orderpendingapproval" ||
                                  reservation.state == "orderdateconflict") ...[
                                Center(
                                    child: ElevatedButton(
                                  onPressed: () async {
                                    await _confirmCancel(reservation.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Cancel Reservation'),
                                )),
                                const SizedBox(width: 8.0),
                                Center(
                                    child: ElevatedButton(
                                  onPressed: () async {
                                    if (order != null) {
                                      if (order.state == "accepted") {
                                        await showUpdateForm(
                                            reservation,
                                            DateTime.parse(
                                                order.shippingDate!));
                                      } else {
                                        await showUpdateForm(reservation, null);
                                      }
                                    } else {
                                      await showUpdateForm(reservation, null);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 31, 75, 157),
                                  ),
                                  child: const Text('Update Reservation Date'),
                                )),
                                const SizedBox(width: 8.0),
                              ],
                              if (reservation.state == "rejected" ||
                                  reservation.state == "cancelled" ||
                                  reservation.state == "completed" ||
                                  reservation.state == "missingpayment" ||
                                  reservation.state == "paymentfailed") ...[
                                ElevatedButton(
                                  onPressed: () async {
                                    await _confirmDelete(reservation.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Delete From History'),
                                ),
                              ],
                              const SizedBox(width: 8.0),
                              Center(
                                  child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).hoverColor,
                                ),
                                child: const Text("Close"),
                              )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _clearCompletionDates() {
    setState(() {
      filterCriteria.maxCompletionDate = null;
      filterCriteria.minCompletionDate = null;
    });
  }

  void _clearEstimatedCompletionDates() {
    setState(() {
      filterCriteria.maxEstimatedCompletionDate = null;
      filterCriteria.minEstimatedCompletionDate = null;
    });
  }

  final double _minValue = 0.0;
  final double _maxValue = 10000.0;

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Filters"),
          content: SizedBox(
            width: double.maxFinite,
            child: _buildFilterMenu(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterMenu() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return ListView(
          children: [
            ExpansionTile(
              title: const Text("State"),
              children: [
                RadioListTile(
                  title: const Text("All"),
                  value: null,
                  groupValue: filterCriteria.state,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.state = value;
                    });
                    _clearCompletionDates();
                    _clearEstimatedCompletionDates();
                  },
                ),
                if (filterCriteria.type != "Diagnostics") ...[
                  RadioListTile(
                    title: const Text("Awaiting Order"),
                    value: "awaitingorder",
                    groupValue: filterCriteria.state,
                    onChanged: (value) {
                      setState(() {
                        filterCriteria.state = value;
                      });
                      _clearCompletionDates();
                      _clearEstimatedCompletionDates();
                    },
                  ),
                  RadioListTile(
                    title: const Text("Order Pending Approval"),
                    value: "orderpendingapproval",
                    groupValue: filterCriteria.state,
                    onChanged: (value) {
                      setState(() {
                        filterCriteria.state = value;
                      });
                      _clearCompletionDates();
                      _clearEstimatedCompletionDates();
                    },
                  ),
                  RadioListTile(
                    title: const Text("Order Date Conflict"),
                    value: "orderdateconflict",
                    groupValue: filterCriteria.state,
                    onChanged: (value) {
                      setState(() {
                        filterCriteria.state = value;
                      });
                      _clearCompletionDates();
                      _clearEstimatedCompletionDates();
                    },
                  ),
                ],
                RadioListTile(
                  title: const Text("Overbooked"),
                  value: "overbooked",
                  groupValue: filterCriteria.state,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.state = value;
                    });
                    _clearCompletionDates();
                    _clearEstimatedCompletionDates();
                  },
                ),
                RadioListTile(
                  title: const Text("Ready"),
                  value: "ready",
                  groupValue: filterCriteria.state,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.state = value;
                    });
                    _clearCompletionDates();
                    _clearEstimatedCompletionDates();
                  },
                ),
                RadioListTile(
                  title: const Text("Accepted"),
                  value: "accepted",
                  groupValue: filterCriteria.state,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.state = value;
                    });
                    _clearCompletionDates();
                  },
                ),
                RadioListTile(
                  title: const Text("Ongoing"),
                  value: "ongoing",
                  groupValue: filterCriteria.state,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.state = value;
                    });
                    _clearCompletionDates();
                  },
                ),
                RadioListTile(
                  title: const Text("Completed"),
                  value: "completed",
                  groupValue: filterCriteria.state,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.state = value;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text("Rejected"),
                  value: "rejected",
                  groupValue: filterCriteria.state,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.state = value;
                    });
                    _clearCompletionDates();
                    _clearEstimatedCompletionDates();
                  },
                ),
                RadioListTile(
                  title: const Text("Cancelled"),
                  value: "cancelled",
                  groupValue: filterCriteria.state,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.state = value;
                    });
                    _clearCompletionDates();
                    _clearEstimatedCompletionDates();
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text("Type"),
              children: [
                RadioListTile(
                  title: const Text("All"),
                  value: null,
                  groupValue: filterCriteria.type,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.type = value;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text("Repairs"),
                  value: "Repairs",
                  groupValue: filterCriteria.type,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.type = value;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text("Diagnostics"),
                  value: "Diagnostics",
                  groupValue: filterCriteria.type,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.type = value;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text("Repairs and Diagnostics"),
                  value: "Repairs and Diagnostics",
                  groupValue: filterCriteria.type,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.type = value;
                    });
                  },
                ),
              ],
            ),
            if (filterCriteria.state == "completed") ...[
              ExpansionTile(
                title: const Text("Completion Period"),
                children: [
                  ListTile(
                    title: const Text('Start Completion Date'),
                    subtitle: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                filterCriteria.minCompletionDate = selectedDate;
                                filterCriteria.maxCompletionDate = null;
                              });
                            }
                          },
                          child: Text(
                            filterCriteria.minCompletionDate != null
                                ? DateFormat('dd.MM.yyyy')
                                    .format(filterCriteria.minCompletionDate!)
                                : "Select Date",
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              filterCriteria.minCompletionDate = null;
                            });
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),
                  ),
                  if (filterCriteria.minCompletionDate != null) ...[
                    ListTile(
                      title: const Text('End Completion Date'),
                      subtitle: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: filterCriteria.minCompletionDate!,
                                firstDate: filterCriteria.minCompletionDate!,
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  filterCriteria.maxCompletionDate =
                                      selectedDate;
                                });
                              }
                            },
                            child: Text(
                              filterCriteria.maxCompletionDate != null
                                  ? DateFormat('dd.MM.yyyy')
                                      .format(filterCriteria.maxCompletionDate!)
                                  : "Select Date",
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                filterCriteria.maxCompletionDate = null;
                              });
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              )
            ],
            if (filterCriteria.state == "accepted" ||
                filterCriteria.state == "ongoing" ||
                filterCriteria.state == "completed") ...[
              ExpansionTile(
                title: const Text("Estimated Completion Period"),
                children: [
                  ListTile(
                    title: const Text('Start Estimated Completion Date'),
                    subtitle: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                filterCriteria.minEstimatedCompletionDate =
                                    selectedDate;
                                filterCriteria.maxEstimatedCompletionDate =
                                    null;
                              });
                            }
                          },
                          child: Text(
                            filterCriteria.minEstimatedCompletionDate != null
                                ? DateFormat('dd.MM.yyyy').format(
                                    filterCriteria.minEstimatedCompletionDate!)
                                : "Select Date",
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              filterCriteria.minEstimatedCompletionDate = null;
                            });
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),
                  ),
                  if (filterCriteria.minEstimatedCompletionDate != null) ...[
                    ListTile(
                      title: const Text('End Estimated Completion Date'),
                      subtitle: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    filterCriteria.minEstimatedCompletionDate!,
                                firstDate:
                                    filterCriteria.minEstimatedCompletionDate!,
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  filterCriteria.maxEstimatedCompletionDate =
                                      selectedDate;
                                });
                              }
                            },
                            child: Text(
                              filterCriteria.maxEstimatedCompletionDate != null
                                  ? DateFormat('dd.MM.yyyy').format(
                                      filterCriteria
                                          .maxEstimatedCompletionDate!)
                                  : "Select Date",
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                filterCriteria.maxEstimatedCompletionDate =
                                    null;
                              });
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              )
            ],
            ExpansionTile(title: const Text("Reservation period"), children: [
              ListTile(
                title: const Text('Start Reservation Date'),
                subtitle: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            filterCriteria.minReservationDate = selectedDate;
                            filterCriteria.maxReservationDate = null;
                          });
                        }
                      },
                      child: Text(
                        filterCriteria.minReservationDate != null
                            ? DateFormat('dd.MM.yyyy')
                                .format(filterCriteria.minReservationDate!)
                            : "Select Date",
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          filterCriteria.minReservationDate = null;
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
              ),
              if (filterCriteria.minReservationDate != null) ...[
                ListTile(
                  title: const Text('End Reservation Date'),
                  subtitle: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: filterCriteria.minReservationDate!,
                            firstDate: filterCriteria.minReservationDate!,
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              filterCriteria.maxReservationDate = selectedDate;
                            });
                          }
                        },
                        child: Text(
                          filterCriteria.maxReservationDate != null
                              ? DateFormat('dd.MM.yyyy')
                                  .format(filterCriteria.maxReservationDate!)
                              : "Select Date",
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            filterCriteria.maxReservationDate = null;
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                ),
              ]
            ]),
            ExpansionTile(title: const Text("Reservation Created"), children: [
              ListTile(
                title: const Text('Start Reservation Created Date'),
                subtitle: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            filterCriteria.minCreatedDate = selectedDate;
                            filterCriteria.maxCreatedDate = null;
                          });
                        }
                      },
                      child: Text(
                        filterCriteria.minCreatedDate != null
                            ? DateFormat('dd.MM.yyyy')
                                .format(filterCriteria.minCreatedDate!)
                            : "Select Date",
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          filterCriteria.minCreatedDate = null;
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
              ),
              if (filterCriteria.minCreatedDate != null) ...[
                ListTile(
                  title: const Text('End Reservation Created Date'),
                  subtitle: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: filterCriteria.minCreatedDate!,
                            firstDate: filterCriteria.minCreatedDate!,
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              filterCriteria.maxCreatedDate = selectedDate;
                            });
                          }
                        },
                        child: Text(
                          filterCriteria.maxCreatedDate != null
                              ? DateFormat('dd.MM.yyyy')
                                  .format(filterCriteria.maxCreatedDate!)
                              : "Select Date",
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            filterCriteria.maxCreatedDate = null;
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                ),
              ]
            ]),
            ExpansionTile(
              title: const Text("Discount"),
              children: [
                RadioListTile(
                  title: const Text("All"),
                  value: null,
                  groupValue: filterCriteria.discount,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.discount = value;
                    });
                    _clearCompletionDates();
                  },
                ),
                RadioListTile(
                  title: const Text("With client discount"),
                  value: true,
                  groupValue: filterCriteria.discount,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.discount = value;
                    });
                    _clearCompletionDates();
                  },
                ),
                RadioListTile(
                  title: const Text("Without client discount"),
                  value: false,
                  groupValue: filterCriteria.discount,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.discount = value;
                    });
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text("Parts order handled by"),
              children: [
                RadioListTile(
                  title: const Text("All"),
                  value: null,
                  groupValue: filterCriteria.clientOrder,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.clientOrder = value;
                    });
                    _clearCompletionDates();
                  },
                ),
                RadioListTile(
                  title: const Text("Me"),
                  value: true,
                  groupValue: filterCriteria.clientOrder,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.clientOrder = value;
                    });
                    _clearCompletionDates();
                  },
                ),
                RadioListTile(
                  title: const Text("Shop"),
                  value: false,
                  groupValue: filterCriteria.clientOrder,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.clientOrder = value;
                    });
                  },
                ),
              ],
            ),
            ExpansionTile(title: const Text("Reservation price"), children: [
              RangeSlider(
                values: RangeValues(
                  filterCriteria.minTotalAmount ?? _minValue,
                  filterCriteria.maxTotalAmount ?? _maxValue,
                ),
                min: _minValue,
                max: _maxValue,
                divisions: 100,
                labels: RangeLabels(
                  filterCriteria.minTotalAmount != null
                      ? filterCriteria.minTotalAmount!.toStringAsFixed(0)
                      : _minValue.toStringAsFixed(0),
                  filterCriteria.maxTotalAmount != null
                      ? filterCriteria.maxTotalAmount!.toStringAsFixed(0)
                      : _maxValue.toStringAsFixed(0),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    filterCriteria.minTotalAmount = values.start;
                    filterCriteria.maxTotalAmount = values.end;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("${filterCriteria.minTotalAmount!.toStringAsFixed(0)}€"),
                  const SizedBox(width: 10),
                  Text("${filterCriteria.maxTotalAmount!.toStringAsFixed(0)}€"),
                ],
              ),
              const SizedBox(height: 10),
            ]),
            ListTile(
              title: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _pageNumber = 1;
                  });
                  await Provider.of<ReservationProvider>(context, listen: false)
                      .getByClient(
                          reservationSearch: filterCriteria,
                          pageNumber: _pageNumber,
                          pageSize: _pageSize);
                },
                child: const Text("Apply Filters"),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);
    final reservations = reservationProvider.reservations;
    final isLoading = reservationProvider.isLoading;
    if (!isLoading) {
      _totalPages = (reservationProvider.countOfItems / _pageSize).ceil();
    }
    return Scaffold(
      body: MasterScreen(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _showFilterDialog,
                    label: const Text("Show Filters"),
                  ),
                  reservations.isEmpty
                      ? const Expanded(
                          child:
                              Center(child: Text('No reservations to show.')))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: reservations.length,
                            itemBuilder: (context, index) {
                              final reservation = reservations[index];
                              return ListTile(
                                title: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Reservation #${reservation.id}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Car Repair Shop: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text:
                                                  reservation.carRepairShopName)
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Reservation Date: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text: _formatDate(
                                                  reservation.reservationDate))
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Total Amount: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text:
                                                  '${reservation.totalAmount.toStringAsFixed(2)}€')
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Personal Discount: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text:
                                                  '${(reservation.carRepairShopDiscountValue * 100).toStringAsFixed(2)}%')
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'State: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text: _getDisplayState(
                                                  reservation.state),
                                              style: TextStyle(
                                                  color: _getStateColor(
                                                      reservation.state))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.info_outline),
                                      onPressed: () {
                                        _showReservationDetails(
                                            context, reservation);
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  _showReservationDetails(context, reservation);
                                },
                              );
                            },
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _pageNumber > 1
                            ? () async {
                                setState(() {
                                  _pageNumber = _pageNumber - 1;
                                });
                                await Provider.of<ReservationProvider>(context,
                                        listen: false)
                                    .getByClient(
                                        reservationSearch: filterCriteria,
                                        pageNumber: _pageNumber,
                                        pageSize: _pageSize);
                              }
                            : null,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      Text('$_pageNumber',
                          style: Theme.of(context).textTheme.bodyLarge),
                      IconButton(
                        onPressed: _pageNumber < _totalPages
                            ? () async {
                                setState(() {
                                  _pageNumber = _pageNumber + 1;
                                });
                                await Provider.of<ReservationProvider>(context,
                                        listen: false)
                                    .getByClient(
                                        reservationSearch: filterCriteria,
                                        pageNumber: _pageNumber,
                                        pageSize: _pageSize);
                              }
                            : null,
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'shopsButton',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CarRepairShopsScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).hoverColor,
        child: const Icon(Icons.shop, color: Colors.white),
      ),
    );
  }
}
