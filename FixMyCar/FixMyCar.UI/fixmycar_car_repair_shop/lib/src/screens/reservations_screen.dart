import 'package:fixmycar_car_repair_shop/src/models/reservation/reservation_search_object.dart';
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

  String _formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  String _getDisplayState(String state) {
    switch (state) {
      case "onholdwithoutorder":
        return "On hold (Without Order)";
      case "onholdwithorder":
        return "On hold (With Order)";
      case "accepted":
        return "Accepted";
      case "completed":
        return "Completed";
      case "rejected":
        return "Rejected";
      case "cancelled":
        return "Cancelled";
      default:
        return state;
    }
  }

  Color _getStateColor(String state) {
    switch (state) {
      case 'onholdwithoutorder':
        return Colors.blue.shade300;
      case 'onholdwithorder':
        return Colors.blue.shade500;
      case 'accepted':
        return Colors.green.shade300;
      case 'completed':
        return Colors.green.shade500;
      case 'rejected':
        return Colors.red.shade700;
      case 'cancelled':
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
        content: const Text('Are you sure you want to reject this reservation?'),
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

  Future _confirmAccept(int reservationId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Accept'),
        content: const Text('Are you sure you want to accept this reservation?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<ReservationProvider>(context, listen: false)
                    .accept(reservationId)
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

  Future<void> _showReservationDetails(BuildContext context, Reservation reservation) async {
    final reservationDetailProvider =
        Provider.of<ReservationDetailProvider>(context, listen: false);

    await reservationDetailProvider.getByReservation(id: reservation.id);

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
                            TextSpan(text: _formatDate(reservation.reservationCreatedDate)),
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
                            TextSpan(text: _formatDate(reservation.reservationDate)),
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
                            TextSpan(text: _getDisplayState(reservation.state)),
                          ],
                        ),
                      ),
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
                          if (reservation.state == "onholdwithoutorder" || reservation.state == "onholdwithorder") ...[
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
                            ElevatedButton(
                              onPressed: () async {
                                await _confirmAccept(reservation.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).hoverColor,
                              ),
                              child: const Text("Accept Reservation"),
                            ),
                          ]
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
                },
              ),
              RadioListTile(
                title: const Text("On hold (Without Order)"),
                value: "onholdwithoutorder",
                groupValue: filterCriteria.state,
                onChanged: (value) {
                  setState(() {
                    filterCriteria.state = value;
                  });
                  _clearCompletionDates();
                },
              ),
              RadioListTile(
                title: const Text("On hold (With Order)"),
                value: "onholdwithorder",
                groupValue: filterCriteria.state,
                onChanged: (value) {
                  setState(() {
                    filterCriteria.state = value;
                  });
                  _clearCompletionDates();
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
                },
              ),
            ],
          ),
          if (filterCriteria.state == "completed") ...[
            ExpansionTile(
              title: const Text("Completion period"),
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
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterMenu(),
                reservations.isEmpty
                    ? const Expanded(
                        child: Center(child: Text('No reservations available.')))
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
                                        TextSpan(text: reservation.clientUsername)
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Reservation Created Date: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: _formatDate(reservation.reservationCreatedDate))
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
                                            text: _formatDate(reservation.reservationDate))
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
                                            text: reservation.completionDate == null
                                                ? "Not completed"
                                                : _formatDate(
                                                    reservation.completionDate!))
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
                                            text:
                                                '€${reservation.totalDuration}')
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
                                            text: _getDisplayState(reservation.state),
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
                                    icon: reservation.state == "onholdwithoutorder"
                                        ? const Icon(Icons.settings)
                                        : reservation.state == "onholdwithorder" ? const Icon(Icons.settings) : const Icon(Icons.info_outline),
                                    onPressed: () {
                                      _showReservationDetails(context, reservation);
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
