import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'master_screen.dart';
import 'package:fixmycar_car_parts_shop/src/providers/car_parts_shop_client_discount_provider.dart';
import 'package:fixmycar_car_parts_shop/src/models/car_parts_shop_client_discount/car_parts_shop_client_discount_insert_update.dart';
import 'package:intl/intl.dart';

class DiscountsScreen extends StatefulWidget {
  const DiscountsScreen({Key? key}) : super(key: key);

  @override
  _DiscountsScreenState createState() => _DiscountsScreenState();
}

class _DiscountsScreenState extends State<DiscountsScreen> {
  bool _isEditing = false;
  int? _editingDiscountId;
  final _editDiscountController = TextEditingController();
  String? _selectedRole = 'All';
  String? _selectedStatus = 'All';

  final _usernameController = TextEditingController();
  final _discountValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CarPartsShopClientDiscountProvider>(context,
              listen: false)
          .getByCarPartsShop();
    });
  }

  void _startEditing(int discountId, String currentValue) {
    setState(() {
      _isEditing = true;
      _editingDiscountId = discountId;
      _editDiscountController.text = currentValue;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _editingDiscountId = null;
    });
  }

  Future<void> _applyChanges(double value) async {
    CarPartsShopClientDiscountInsertUpdate updatedDiscount =
        CarPartsShopClientDiscountInsertUpdate.n();
    final discountValueText = _editDiscountController.text;
    final discountValue = double.tryParse(discountValueText);
    if (discountValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid numeric discount value!'),
        ),
      );
    } else {
      updatedDiscount.value = discountValue / 100;
      await Provider.of<CarPartsShopClientDiscountProvider>(context,
              listen: false)
          .updateDiscount(_editingDiscountId!, updatedDiscount)
          .then((_) {
        Provider.of<CarPartsShopClientDiscountProvider>(context, listen: false)
            .getByCarPartsShop();
      });
      _cancelEditing();
    }
  }

  void _confirmDeactivate(int discountId, double value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deactivation'),
        content:
            const Text('Are you sure you want to deactivate this discount?'),
        actions: [
          TextButton(
            onPressed: () async {
              CarPartsShopClientDiscountInsertUpdate updatedDiscount =
                  CarPartsShopClientDiscountInsertUpdate(null, value, true);
              await Provider.of<CarPartsShopClientDiscountProvider>(context,
                      listen: false)
                  .updateDiscount(discountId, updatedDiscount)
                  .then((_) {
                Provider.of<CarPartsShopClientDiscountProvider>(context,
                        listen: false)
                    .getByCarPartsShop();
              });
              Navigator.of(context).pop();
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

  void _applyFilters() {
    String? role;

    if (_selectedRole != 'All') {
      role = _selectedRole == "Car Repair Shop" ? "carrepairshop" : "client";
    } else {
      role = null;
    }

    bool? active = _selectedStatus == 'All'
        ? null
        : _selectedStatus == 'Active'
            ? true
            : false;
    Provider.of<CarPartsShopClientDiscountProvider>(context, listen: false)
        .getByCarPartsShop(role: role, active: active);
  }

  void _showAddForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Discount'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _discountValueController,
                decoration:
                    const InputDecoration(labelText: 'Discount Value (%)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _usernameController.clear();
                _discountValueController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final discountValueText = _discountValueController.text;
                final discountValue = double.tryParse(discountValueText);

                if (_usernameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Username is required!'),
                    ),
                  );
                } else if (discountValue == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Please enter a valid numeric discount value!'),
                    ),
                  );
                } else {
                  CarPartsShopClientDiscountInsertUpdate newDiscount =
                      CarPartsShopClientDiscountInsertUpdate(
                          _usernameController.text, discountValue / 100, null);
                  try {
                    await Provider.of<CarPartsShopClientDiscountProvider>(
                            context,
                            listen: false)
                        .insertDiscount(newDiscount);
                    await Provider.of<CarPartsShopClientDiscountProvider>(
                            context,
                            listen: false)
                        .getByCarPartsShop();
                    _usernameController.clear();
                    _discountValueController.clear();
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
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final discounts =
        Provider.of<CarPartsShopClientDiscountProvider>(context).discounts;
    bool isLoading =
        Provider.of<CarPartsShopClientDiscountProvider>(context).isLoading;

    return MasterScreen(
      showBackButton: false,
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      margin: const EdgeInsets.only(
                          left: 10, top: 10, right: 0, bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Filters',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text('Role'),
                            DropdownButton<String>(
                              value: _selectedRole,
                              items: ['All', 'Client', 'Car Repair Shop']
                                  .map((role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value;
                                  _applyFilters();
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text('Status'),
                            DropdownButton<String>(
                              value: _selectedStatus,
                              items:
                                  ['All', 'Active', 'Inactive'].map((status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value;
                                  _applyFilters();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: discounts.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 200),
                                child: Text('No discounts available.'),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: discounts.length,
                                itemBuilder: (context, index) {
                                  final discount = discounts[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: ListTile(
                                      title: Text(
                                        '${discount.user} (${discount.role})',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${(discount.value * 100).toStringAsFixed(1)}%',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Text(
                                            discount.revoked == null
                                                ? 'Active since: ${_formatDate(discount.created)}'
                                                : 'Deactivated on: ${_formatDate(discount.revoked!)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color:
                                                      discount.revoked == null
                                                          ? Colors.green
                                                          : Colors.red,
                                                ),
                                          ),
                                          if (_isEditing &&
                                              _editingDiscountId == discount.id)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: TextField(
                                                controller:
                                                    _editDiscountController,
                                                decoration: InputDecoration(
                                                  labelText: 'Edit Discount',
                                                  suffixIcon: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.cancel),
                                                        onPressed:
                                                            _cancelEditing,
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.check),
                                                        onPressed: () async =>
                                                            await _applyChanges(
                                                                discount.value),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (discount.revoked == null) ...[
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () => _startEditing(
                                                discount.id,
                                                (discount.value * 100)
                                                    .toStringAsFixed(1),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () =>
                                                  _confirmDeactivate(
                                                      discount.id,
                                                      discount.value),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddForm();
          },
          backgroundColor: Theme.of(context).hoverColor,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editDiscountController.dispose();
    super.dispose();
  }
}
