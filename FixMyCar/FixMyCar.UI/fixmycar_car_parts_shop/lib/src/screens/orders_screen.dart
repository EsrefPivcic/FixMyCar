import 'package:fixmycar_car_parts_shop/src/models/order/order_accept.dart';
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

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<OrderProvider>(context, listen: false)
          .getByCarPartsShop();
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
      default:
        return state;
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
                      .getByCarPartsShop();
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
                              text: 'User: ',
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
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Payment Method: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: order.paymentMethod),
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
                              backgroundColor: Theme.of(context).highlightColor,
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
                                          .getByCarPartsShop();
                                    });
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).highlightColor,
                              ),
                              child: const Text('Accept Order'),
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

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context).orders;
    bool isLoading = Provider.of<OrderProvider>(context).isLoading;

    return MasterScreen(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(
                  child: Text('No orders available',
                      style: TextStyle(fontSize: 18)))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(order.username,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order Date: ${_formatDate(order.orderDate)}'),
                            Text(
                                'Shipping Date: ${order.shippingDate == null ? "No shipping date" : _formatDate(order.shippingDate!)}'),
                            Text(
                                'Total: €${order.totalAmount.toStringAsFixed(2)}'),
                            Text('State: ${_getDisplayState(order.state)}'),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            await _showOrderDetails(context, order);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).highlightColor,
                          ),
                          child: Text(
                              order.state == "onhold" ? "Manage" : "Details"),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
