import 'package:fixmycar_car_parts_shop/src/providers/order_provider.dart';
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
      await Provider.of<OrderProvider>(context, listen: false).getByCarPartsShop();
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

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context).orders;
    bool isLoading = Provider.of<OrderProvider>(context).isLoading;

    return MasterScreen(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(child: Text('No orders available', style: TextStyle(fontSize: 18)))
              : ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(order.username, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Date: ${_formatDate(order.orderDate)}'),
                        Text('Shipping Date: ${order.shippingDate ?? "No shipping date"}'),
                        Text('Total: €${order.totalAmount.toStringAsFixed(2)}'),
                        Text('State: ${_getDisplayState(order.state)}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        if (order.state == "onhold") {
                          //TODO: Navigate to manage screen
                        } else {
                          //TODO: Navigate to details screen
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).highlightColor
                      ),
                      child: Text(order.state == "onhold" ? "Manage" : "Details"),
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
