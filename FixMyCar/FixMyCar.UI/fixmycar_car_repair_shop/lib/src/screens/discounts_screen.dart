import 'package:fixmycar_car_repair_shop/src/models/car_repair_shop_discount/car_repair_shop_discount_insert_update.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'master_screen.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_repair_shop_discount_provider.dart';
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
  String? _selectedStatus = 'All';
  int _pageNumber = 1;
  final int _pageSize = 10;
  int _totalPages = 1;

  final _usernameController = TextEditingController();
  final _discountValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CarRepairShopDiscountProvider>(context, listen: false)
          .getByCarRepairShop(pageNumber: _pageNumber, pageSize: _pageSize);
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

  Future<void> _applyChanges() async {
    CarRepairShopDiscountInsertUpdate updatedDiscount =
        CarRepairShopDiscountInsertUpdate.n();
    final discountValueText = _editDiscountController.text;
    final discountValue = double.tryParse(discountValueText);
    updatedDiscount.value = discountValue! / 100;
    try {
      await Provider.of<CarRepairShopDiscountProvider>(context, listen: false)
          .updateDiscount(_editingDiscountId!, updatedDiscount)
          .then((_) {
        Provider.of<CarRepairShopDiscountProvider>(context, listen: false)
            .getByCarRepairShop(pageNumber: _pageNumber, pageSize: _pageSize);
      });
      _cancelEditing();
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              CarRepairShopDiscountInsertUpdate updatedDiscount =
                  CarRepairShopDiscountInsertUpdate(null, value, true);
              try {
                await Provider.of<CarRepairShopDiscountProvider>(context,
                        listen: false)
                    .updateDiscount(discountId, updatedDiscount)
                    .then((_) {
                  _applyFilters();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Deactivation successful!"),
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
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int discountId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this discount?'),
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
                await Provider.of<CarRepairShopDiscountProvider>(context,
                        listen: false)
                    .delete(discountId)
                    .then((_) {
                  _applyFilters();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Deleting successful!"),
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
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    bool? active = _selectedStatus == 'All'
        ? null
        : _selectedStatus == 'Active'
            ? true
            : false;
    Provider.of<CarRepairShopDiscountProvider>(context, listen: false)
        .getByCarRepairShop(
            active: active, pageNumber: _pageNumber, pageSize: _pageSize);
  }

  void _showAddForm() {
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: const Text('Add New Discount'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a username";
                      }
                      return null;
                    }),
                TextFormField(
                    controller: _discountValueController,
                    decoration:
                        const InputDecoration(labelText: 'Discount Value (%)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a valid value (0-99)";
                      }
                      final discount = double.tryParse(value.trim());
                      if (discount == null) {
                        return "Please enter a valid value (0-99)";
                      }
                      if (discount < 0) {
                        return "Discount can't be lower than 0%";
                      }
                      if (discount > 99) {
                        return "Discount can't be higher than 99%";
                      }
                      return null;
                    }),
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
                  if (_formKey.currentState?.validate() ?? false) {
                    final discountValueText = _discountValueController.text;
                    final discountValue = double.tryParse(discountValueText);

                    CarRepairShopDiscountInsertUpdate newDiscount =
                        CarRepairShopDiscountInsertUpdate(
                            _usernameController.text,
                            discountValue! / 100,
                            null);
                    try {
                      await Provider.of<CarRepairShopDiscountProvider>(context,
                              listen: false)
                          .insertDiscount(newDiscount)
                          .then((_) async {
                        await Provider.of<CarRepairShopDiscountProvider>(
                                context,
                                listen: false)
                            .getByCarRepairShop(
                                pageNumber: _pageNumber, pageSize: _pageSize);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Insert succesful!"),
                        ),
                      );
                      _usernameController.clear();
                      _discountValueController.clear();
                      Navigator.of(context).pop();
                    } catch (e) {
                      Navigator.of(context).pop();
                      _usernameController.clear();
                      _discountValueController.clear();
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
          ),
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
        Provider.of<CarRepairShopDiscountProvider>(context).discounts;
    bool isLoading =
        Provider.of<CarRepairShopDiscountProvider>(context).isLoading;
    if (!isLoading) {
      _totalPages =
          (Provider.of<CarRepairShopDiscountProvider>(context).countOfItems /
                  _pageSize)
              .ceil();
    }
    final List<GlobalKey<FormState>> _formKeys = [];
    _formKeys
        .addAll(List.generate(discounts.length, (_) => GlobalKey<FormState>()));
    return MasterScreen(
      showBackButton: false,
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Row(
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
                          const Text('Status'),
                          DropdownButton<String>(
                            value: _selectedStatus,
                            items: ['All', 'Active', 'Inactive'].map((status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value;
                                _pageNumber = 1;
                                _applyFilters();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  discounts.isEmpty
                      ? const Expanded(
                          child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 200),
                            child: Text('No discounts available.'),
                          ),
                        ))
                      : Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: discounts.length,
                                    itemBuilder: (context, index) {
                                      final discount = discounts[index];
                                      return Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: ListTile(
                                          title: Text(
                                            discount.client,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${(discount.value * 100).toStringAsFixed(2)}%',
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
                                                      color: discount.revoked ==
                                                              null
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                              ),
                                              if (_isEditing &&
                                                  _editingDiscountId ==
                                                      discount.id)
                                                Form(
                                                  key: _formKeys[index],
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value
                                                                .trim()
                                                                .isEmpty) {
                                                          return "Please enter a valid value (0-99)";
                                                        }
                                                        final newDiscount =
                                                            double.tryParse(
                                                                value.trim());
                                                        if (newDiscount ==
                                                            null) {
                                                          return "Please enter a valid value (0-99)";
                                                        }
                                                        if (newDiscount < 0) {
                                                          return "Discount can't be lower than 0%";
                                                        }
                                                        if (newDiscount > 99) {
                                                          return "Discount can't be higher than 99%";
                                                        }
                                                        if (newDiscount / 100 ==
                                                            discount.value) {
                                                          return "New value can't be the same as the old one";
                                                        }
                                                        return null;
                                                      },
                                                      controller:
                                                          _editDiscountController,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Edit Discount',
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
                                                              onPressed:
                                                                  () async {
                                                                if (_formKeys[
                                                                            index]
                                                                        .currentState
                                                                        ?.validate() ??
                                                                    false) {
                                                                  await _applyChanges();
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                )
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (discount.revoked == null) ...[
                                                IconButton(
                                                  tooltip: "Edit",
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () =>
                                                      _startEditing(
                                                    discount.id,
                                                    (discount.value * 100)
                                                        .toStringAsFixed(2),
                                                  ),
                                                ),
                                                IconButton(
                                                  tooltip: "Deactivate",
                                                  icon: const Icon(Icons
                                                      .do_not_disturb_rounded),
                                                  onPressed: () =>
                                                      _confirmDeactivate(
                                                          discount.id,
                                                          discount.value),
                                                ),
                                              ] else
                                                IconButton(
                                                  tooltip:
                                                      "Delete from history",
                                                  icon: const Icon(Icons
                                                      .delete_forever_rounded),
                                                  onPressed: () =>
                                                      _confirmDelete(
                                                          discount.id),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: _pageNumber > 1
                                        ? () {
                                            setState(() {
                                              _pageNumber = _pageNumber - 1;
                                            });
                                            _applyFilters();
                                          }
                                        : null,
                                    icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded),
                                  ),
                                  Text('$_pageNumber',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  IconButton(
                                    onPressed: _pageNumber < _totalPages
                                        ? () {
                                            setState(() {
                                              _pageNumber = _pageNumber + 1;
                                            });
                                            _applyFilters();
                                          }
                                        : null,
                                    icon: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddForm();
          },
          backgroundColor: Theme.of(context).hoverColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editDiscountController.dispose();
    _pageNumber = 1;
    super.dispose();
  }
}
