import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'master_screen.dart';
import 'package:fixmycar_car_parts_shop/src/providers/car_parts_shop_client_discount_provider.dart';

class DiscountsScreen extends StatefulWidget {
  const DiscountsScreen({Key? key}) : super(key: key);

  @override
  _DiscountsScreenState createState() => _DiscountsScreenState();
}

class _DiscountsScreenState extends State<DiscountsScreen> {
  bool _isEditing = false;
  int? _editingIndex;
  final _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CarPartsShopClientDiscountProvider>(context, listen: false).getByCarPartsShop();
    });
  }

  void _startEditing(int index, String currentValue) {
    setState(() {
      _isEditing = true;
      _editingIndex = index;
      _editController.text = currentValue;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _editingIndex = null;
    });
  }

  void _confirmDeactivate(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deactivation'),
        content: const Text('Are you sure you want to deactivate this discount?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement deactivation logic here
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

  @override
  Widget build(BuildContext context) {
    final discounts = Provider.of<CarPartsShopClientDiscountProvider>(context).discounts;
    bool isLoading = Provider.of<CarPartsShopClientDiscountProvider>(context).isLoading;

    return MasterScreen(
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : discounts.isEmpty
                ? const Center(child: Text('No discounts available.'))
                : ListView.builder(
                    itemCount: discounts.length,
                    itemBuilder: (context, index) {
                      final discount = discounts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          title: Text(
                            '${discount.user} (${discount.role})',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${(discount.value * 100).toStringAsFixed(1)}%',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                discount.revoked == null
                                    ? 'Active'
                                    : 'Deactivated on: ${discount.revoked}',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: discount.revoked == null ? Colors.green : Colors.red,
                                    ),
                              ),
                              if (_isEditing && _editingIndex == index)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextField(
                                    controller: _editController,
                                    decoration: InputDecoration(
                                      labelText: 'Edit Discount',
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.cancel),
                                        onPressed: _cancelEditing,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _startEditing(index, (discount.value * 100).toStringAsFixed(1)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _confirmDeactivate(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }
}
