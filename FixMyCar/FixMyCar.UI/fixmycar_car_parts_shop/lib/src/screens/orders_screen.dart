import 'package:fixmycar_car_parts_shop/src/models/order/order_accept.dart';
import 'package:fixmycar_car_parts_shop/src/models/order/order_search_object.dart';
import 'package:fixmycar_car_parts_shop/src/providers/order_detail_provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/order_provider.dart';
import 'package:fixmycar_car_parts_shop/src/models/order/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'master_screen.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

OrderSearchObject filterCriteria =
    OrderSearchObject.n(minTotalAmount: 0, maxTotalAmount: 10000);

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<OrderProvider>(context, listen: false)
          .getByCarPartsShop(orderSearch: filterCriteria);
    });
  }

  String _formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  String _getDisplayState(String state) {
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

  Color _getStateColor(String state) {
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

  Future _confirmReject(int orderId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Reject'),
        content: const Text('Are you sure you want to reject this order?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<OrderProvider>(context, listen: false)
                    .reject(orderId)
                    .then((_) {
                  Provider.of<OrderProvider>(context, listen: false)
                      .getByCarPartsShop(orderSearch: filterCriteria);
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

  Future<void> _showOrderDetails(BuildContext context, Order order) async {
    final orderDetailProvider =
        Provider.of<OrderDetailProvider>(context, listen: false);

    await orderDetailProvider.getByOrder(id: order.id);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final orderDetails = orderDetailProvider.orderDetails;
        final isLoading = orderDetailProvider.isLoading;

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
                        'Order Details',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8.0),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Customer: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: order.username),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Order Date: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: _formatDate(order.orderDate)),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Shipping Date: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: order.shippingDate == null
                                  ? "No shipping date"
                                  : _formatDate(order.shippingDate!),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Total: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text:
                                    '€${order.totalAmount.toStringAsFixed(2)}'),
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
                                    '${(order.clientDiscountValue * 100).toStringAsFixed(2)}%'),
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
                            TextSpan(text: _getDisplayState(order.state)),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Shipping City: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: order.shippingCity),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Shipping Address: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: order.shippingAddress),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Postal Code: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: order.shippingPostalCode),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Order Items',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8.0),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: orderDetails.length,
                          itemBuilder: (context, index) {
                            final orderDetail = orderDetails[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ExpansionTile(
                                title: Text(orderDetail.storeItemName),
                                subtitle: Text(
                                    'Quantity: ${orderDetail.quantity}, Total: €${orderDetail.totalItemsPrice.toStringAsFixed(2)}'),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Unit Price: €${orderDetail.unitPrice.toStringAsFixed(2)}'),
                                        Text(
                                            'Total Items Price: €${orderDetail.totalItemsPrice.toStringAsFixed(2)}'),
                                        Text(
                                            'Discounted Price: €${orderDetail.totalItemsPriceDiscounted.toStringAsFixed(2)}'),
                                        Text(
                                            'Discount: ${orderDetail.discount * 100}%'),
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
                          if (order.state == "onhold") ...[
                            ElevatedButton(
                              onPressed: () async {
                                await _confirmReject(order.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Reject Order'),
                            ),
                            const SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed: () async {
                                final DateTime? selectedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (selectedDate != null) {
                                  final OrderAccept orderAccept =
                                      OrderAccept(selectedDate);
                                  try {
                                    await Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .accept(order.id, orderAccept)
                                        .then((_) {
                                      Provider.of<OrderProvider>(context,
                                              listen: false)
                                          .getByCarPartsShop(
                                              orderSearch: filterCriteria);
                                    });
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).hoverColor,
                              ),
                              child: const Text("Accept Order"),
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

  void _clearShippingDates() {
    setState(() {
      filterCriteria.maxShippingDate = null;
      filterCriteria.minShippingDate = null;
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
                  _clearShippingDates();
                },
              ),
              RadioListTile(
                title: const Text("On hold"),
                value: "onhold",
                groupValue: filterCriteria.state,
                onChanged: (value) {
                  setState(() {
                    filterCriteria.state = value;
                  });
                  _clearShippingDates();
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
                  _clearShippingDates();
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
                  _clearShippingDates();
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
                  _clearShippingDates();
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
                  _clearShippingDates();
                },
              ),
            ],
          ),
          if (filterCriteria.state == "accepted") ...[
            ExpansionTile(
              title: const Text("Shipping period"),
              children: [
                ListTile(
                  title: const Text('Start Shipping Date'),
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
                              filterCriteria.minShippingDate = selectedDate;
                              filterCriteria.maxShippingDate = null;
                            });
                          }
                        },
                        child: Text(
                          filterCriteria.minShippingDate != null
                              ? DateFormat('dd.MM.yyyy')
                                  .format(filterCriteria.minShippingDate!)
                              : "Select Date",
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            filterCriteria.minShippingDate = null;
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                ),
                if (filterCriteria.minShippingDate != null) ...[
                  ListTile(
                    title: const Text('End Shipping Date'),
                    subtitle: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: filterCriteria.minShippingDate!,
                              firstDate: filterCriteria.minShippingDate!,
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                filterCriteria.maxShippingDate = selectedDate;
                              });
                            }
                          },
                          child: Text(
                            filterCriteria.maxShippingDate != null
                                ? DateFormat('dd.MM.yyyy')
                                    .format(filterCriteria.maxShippingDate!)
                                : "Select Date",
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              filterCriteria.maxShippingDate = null;
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
          ExpansionTile(title: const Text("Order period"), children: [
            ListTile(
              title: const Text('Start Order Date'),
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
                          filterCriteria.minOrderDate = selectedDate;
                          filterCriteria.maxOrderDate = null;
                        });
                      }
                    },
                    child: Text(
                      filterCriteria.minOrderDate != null
                          ? DateFormat('dd.MM.yyyy')
                              .format(filterCriteria.minOrderDate!)
                          : "Select Date",
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        filterCriteria.minOrderDate = null;
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
            ),
            if (filterCriteria.minOrderDate != null) ...[
              ListTile(
                title: const Text('End Order Date'),
                subtitle: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: filterCriteria.minOrderDate!,
                          firstDate: filterCriteria.minOrderDate!,
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            filterCriteria.maxOrderDate = selectedDate;
                          });
                        }
                      },
                      child: Text(
                        filterCriteria.maxOrderDate != null
                            ? DateFormat('dd.MM.yyyy')
                                .format(filterCriteria.maxOrderDate!)
                            : "Select Date",
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          filterCriteria.maxOrderDate = null;
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
            title: const Text("Customer role"),
            children: [
              RadioListTile(
                title: const Text("All"),
                value: null,
                groupValue: filterCriteria.role,
                onChanged: (value) {
                  setState(() {
                    filterCriteria.role = value;
                  });
                  _clearShippingDates();
                },
              ),
              RadioListTile(
                title: const Text("Client"),
                value: "client",
                groupValue: filterCriteria.role,
                onChanged: (value) {
                  setState(() {
                    filterCriteria.role = value;
                  });
                  _clearShippingDates();
                },
              ),
              RadioListTile(
                title: const Text("Car Repair Shop"),
                value: "carrepairshop",
                groupValue: filterCriteria.role,
                onChanged: (value) {
                  setState(() {
                    filterCriteria.role = value;
                  });
                },
              ),
            ],
          ),
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
                  _clearShippingDates();
                },
              ),
              RadioListTile(
                title: const Text("With customer discount"),
                value: true,
                groupValue: filterCriteria.discount,
                onChanged: (value) {
                  setState(() {
                    filterCriteria.discount = value;
                  });
                  _clearShippingDates();
                },
              ),
              RadioListTile(
                title: const Text("Without customer discount"),
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
          ExpansionTile(title: const Text("Order value"), children: [
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
                await Provider.of<OrderProvider>(context, listen: false)
                    .getByCarPartsShop(orderSearch: filterCriteria);
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
    final ordersProvider = Provider.of<OrderProvider>(context);
    final orders = ordersProvider.orders;
    final isLoading = ordersProvider.isLoading;

    return MasterScreen(
      showBackButton: false,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterMenu(),
                orders.isEmpty
                    ? const Expanded(
                        child: Center(child: Text('No orders available.')))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return ListTile(
                              title: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Order #${order.id}',
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
                                          text: 'Customer: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: order.username)
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Order Date: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: _formatDate(order.orderDate))
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Shipping Date: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: order.shippingDate == null
                                                ? "No shipping date"
                                                : _formatDate(
                                                    order.shippingDate!))
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
                                                '€${order.totalAmount.toStringAsFixed(2)}')
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
                                                '${order.clientDiscountValue * 100}%')
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
                                            text: _getDisplayState(order.state),
                                            style: TextStyle(
                                                color: _getStateColor(
                                                    order.state))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: order.state == "onhold"
                                        ? const Icon(Icons.settings)
                                        : const Icon(Icons.info_outline),
                                    onPressed: () {
                                      _showOrderDetails(context, order);
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showOrderDetails(context, order);
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
