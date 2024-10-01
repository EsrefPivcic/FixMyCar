import 'package:fixmycar_car_repair_shop/src/models/order/order_essential.dart';
import 'package:fixmycar_car_repair_shop/src/models/reservation/reservation_search_object.dart';
import 'package:fixmycar_car_repair_shop/src/providers/order_essential_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/reservation_detail_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/reservation_provider.dart';
import 'package:fixmycar_car_repair_shop/src/models/reservation/reservation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'master_screen.dart';
import 'package:intl/intl.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  _ReservationsScreen createState() => _ReservationsScreen();
}

ReservationSearchObject filterCriteria =
    ReservationSearchObject.n(minTotalAmount: 0, maxTotalAmount: 10000);

class _ReservationsScreen extends State<ReservationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ReservationProvider>(context, listen: false)
          .getByCarRepairShop(reservationSearch: filterCriteria);
    });
  }

  final _orderController = TextEditingController();

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
      case 'onhold':
        return Colors.blue.shade300;
      case 'accepted':
        return Colors.green.shade400;
      case 'rejected':
        return Colors.red.shade700;
      case 'cancelled':
        return Colors.red.shade400;
      case 'paymentfailed':
        return Colors.red.shade700;
      case 'missingpayment':
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
        return "Order Date Conflict";
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
      default:
        return state;
    }
  }

  Color _getStateColor(String state) {
    switch (state) {
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
      case 'missingpayment':
        return Colors.red.shade400;
      default:
        return Colors.white;
    }
  }

  Future _confirmReject(int reservationId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Reject'),
        content:
            const Text('Are you sure you want to reject this reservation?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<ReservationProvider>(context, listen: false)
                    .reject(reservationId)
                    .then((_) {
                  Provider.of<ReservationProvider>(context, listen: false)
                      .getByCarRepairShop(reservationSearch: filterCriteria);
                });
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              } catch (e) {
                Navigator.of(context).pop();
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  Future _confirmStart(int reservationId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Start'),
        content: const Text('Are you sure you want to start this reservation?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<ReservationProvider>(context, listen: false)
                    .start(reservationId)
                    .then((_) {
                  Provider.of<ReservationProvider>(context, listen: false)
                      .getByCarRepairShop(reservationSearch: filterCriteria);
                });
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              } catch (e) {
                Navigator.of(context).pop();
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  Future _confirmComplete(int reservationId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Completion'),
        content:
            const Text('Are you sure you want to complete this reservation?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<ReservationProvider>(context, listen: false)
                    .complete(reservationId)
                    .then((_) {
                  Provider.of<ReservationProvider>(context, listen: false)
                      .getByCarRepairShop(reservationSearch: filterCriteria);
                });
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              } catch (e) {
                Navigator.of(context).pop();
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  Future _addOrder(int reservationId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _orderController,
                decoration: const InputDecoration(labelText: 'Order number'),
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
                final orderIdText = _orderController.text;
                final orderId = int.tryParse(orderIdText);

                if (orderId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid order number!'),
                    ),
                  );
                } else {
                  try {
                    await Provider.of<ReservationProvider>(context,
                            listen: false)
                        .addOrder(reservationId, orderId);
                    await Provider.of<ReservationProvider>(context,
                            listen: false)
                        .getByCarRepairShop(reservationSearch: filterCriteria);
                    _orderController.clear();
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
        );
      },
    );
  }

  Future _confirmAccept(int reservationId, String date) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Accept'),
        content:
            const Text('Are you sure you want to accept this reservation?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<ReservationProvider>(context, listen: false)
                    .accept(reservationId, date)
                    .then((_) {
                  Provider.of<ReservationProvider>(context, listen: false)
                      .getByCarRepairShop(reservationSearch: filterCriteria);
                });
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              } catch (e) {
                Navigator.of(context).pop();
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
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
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reservation Details',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8.0),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Client: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: reservation.clientUsername),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Reservation Created On: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text: _formatDate(
                                    reservation.reservationCreatedDate)),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Reservation Date: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text: _formatDate(reservation.reservationDate)),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Estimated Completion Date: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: reservation.estimatedCompletionDate == null
                                  ? "Not accepted"
                                  : _formatDate(
                                      reservation.estimatedCompletionDate!),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Completion Date: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: reservation.completionDate == null
                                  ? "Not completed"
                                  : _formatDate(reservation.completionDate!),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Total price: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text:
                                    '€${reservation.totalAmount.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Discount: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text:
                                    '${(reservation.carRepairShopDiscountValue * 100).toStringAsFixed(2)}%'),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'State: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text: _getDisplayState(reservation.state),
                                style: TextStyle(
                                    color: _getStateColor(reservation.state))),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Type: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: reservation.type),
                          ],
                        ),
                      ),
                      if (reservation.type != "Diagnostics") ...[
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Parts order handled by: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text: reservation.clientOrder == true
                                      ? "Client"
                                      : "Shop"),
                            ],
                          ),
                        ),
                        if (order != null) ...[
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ExpansionTile(
                              title: Text(
                                  'Ordered from: ${order.carPartsShopName}'),
                              subtitle: Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'State: ',
                                    ),
                                    TextSpan(
                                      text: _getOrderDisplayState(order.state),
                                      style: TextStyle(
                                          color: _getOrderStateColor(order
                                              .state)), // Color for the state
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
                                          'Order date: ${_formatDate(order.orderDate)}'),
                                      Text(
                                          'Shipping date: ${order.shippingDate != null ? _formatDate(order.shippingDate!) : 'Not accepted'}'),
                                      Text('Items: ${order.items.join(', ')}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Services Duration: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: reservation.totalDuration),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Payment Method: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: reservation.paymentMethod),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Services',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8.0),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: reservationDetails.length,
                          itemBuilder: (context, index) {
                            final reservationDetail = reservationDetails[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ExpansionTile(
                                title: Text(reservationDetail.serviceName),
                                subtitle: Text(
                                    'Price (Discount Applied): ${reservationDetail.serviceDiscountedPrice}'),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Non-Discounted Price: €${reservationDetail.servicePrice.toStringAsFixed(2)}'),
                                        Text(
                                            'Discount: ${reservationDetail.serviceDiscount * 100}%'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).hoverColor,
                            ),
                            child: const Text("Close"),
                          ),
                          const SizedBox(width: 8.0),
                          if (reservation.state == "awaitingorder" ||
                              reservation.state == "ready" ||
                              reservation.state == "orderpendingapproval" ||
                              reservation.state == "orderdateconflict") ...[
                            ElevatedButton(
                              onPressed: () async {
                                await _confirmReject(reservation.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Reject Reservation'),
                            ),
                            const SizedBox(width: 8.0),
                          ],
                          if (reservation.state == "awaitingorder" &&
                              reservation.clientOrder == false) ...[
                            ElevatedButton(
                              onPressed: () async {
                                await _addOrder(reservation.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 26, 115, 156),
                              ),
                              child: const Text('Add Order'),
                            ),
                            const SizedBox(width: 8.0),
                          ],
                          if (reservation.state == "ready") ...[
                            ElevatedButton(
                              onPressed: () async {
                                final DateTime? selectedDate =
                                    await showDatePicker(
                                        context: context,
                                        initialDate:
                                            DateTime.parse(
                                                reservation.reservationDate),
                                        firstDate: DateTime.parse(
                                            reservation.reservationDate),
                                        lastDate: DateTime(2100),
                                        helpText: "Estimated completion");
                                if (selectedDate != null) {
                                  await await _confirmAccept(reservation.id,
                                      selectedDate.toIso8601String());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).hoverColor,
                              ),
                              child: const Text("Accept Reservation"),
                            ),
                          ],
                          if (reservation.state == "accepted") ...[
                            ElevatedButton(
                              onPressed: () async {
                                await _confirmStart(reservation.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 47, 121, 51),
                              ),
                              child: const Text('Start Reservation'),
                            ),
                          ],
                          if (reservation.state == "ongoing") ...[
                            ElevatedButton(
                              onPressed: () async {
                                await _confirmComplete(reservation.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 47, 121, 51),
                              ),
                              child: const Text('Complete Reservation'),
                            ),
                          ],
                        ],
                      ),
                    ],
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

  Widget _buildFilterMenu() {
    return SizedBox(
      width: 250.0,
      child: ListView(
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
              RadioListTile(
                title: const Text("Missing Payment"),
                value: "missingpayment",
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
                title: const Text("Payment Failed"),
                value: "paymentfailed",
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
                                filterCriteria.maxCompletionDate = selectedDate;
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
                              filterCriteria.maxEstimatedCompletionDate = null;
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
                                    filterCriteria.maxEstimatedCompletionDate!)
                                : "Select Date",
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              filterCriteria.maxEstimatedCompletionDate = null;
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
                title: const Text("Client"),
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
          ]),
          ListTile(
            title: ElevatedButton(
              onPressed: () async {
                await Provider.of<ReservationProvider>(context, listen: false)
                    .getByCarRepairShop(reservationSearch: filterCriteria);
              },
              child: const Text("Apply Filters"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);
    final reservations = reservationProvider.reservations;
    final isLoading = reservationProvider.isLoading;

    return MasterScreen(
      showBackButton: false,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterMenu(),
                reservations.isEmpty
                    ? const Expanded(
                        child:
                            Center(child: Text('No reservations available.')))
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
                                          text: 'Client: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: reservation.clientUsername)
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
                                          text: 'Completion Date: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: reservation.completionDate ==
                                                    null
                                                ? "Not completed"
                                                : _formatDate(reservation
                                                    .completionDate!))
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Total Service Duration: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: reservation.totalDuration)
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
                                                '€${reservation.totalAmount.toStringAsFixed(2)}')
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Discount: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text:
                                                '${reservation.carRepairShopDiscountValue * 100}%')
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
                                    icon: reservation.state == "awaitingorder"
                                        ? const Icon(Icons.settings)
                                        : reservation.state == "ready"
                                            ? const Icon(Icons.settings)
                                            : const Icon(Icons.info_outline),
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
              ],
            ),
    );
  }
}
