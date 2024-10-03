import 'package:fixmycar_client/src/models/car_manufacturer/car_manufacturer.dart';
import 'package:fixmycar_client/src/models/car_model/car_model.dart';
import 'package:fixmycar_client/src/models/car_model/car_models_by_manufacturer.dart';
import 'package:fixmycar_client/src/models/car_parts_shop_discount/car_parts_shop_discount.dart';
import 'package:fixmycar_client/src/models/order/order_insert_update.dart';
import 'package:fixmycar_client/src/models/store_item/store_item.dart';
import 'package:fixmycar_client/src/models/store_item/store_item_order.dart';
import 'package:fixmycar_client/src/models/store_item_category/store_item_category.dart';
import 'package:fixmycar_client/src/models/user/user.dart';
import 'package:fixmycar_client/src/providers/car_models_by_manufacturer_provider.dart';
import 'package:fixmycar_client/src/providers/car_parts_shop_discount_provider.dart';
import 'package:fixmycar_client/src/providers/order_provider.dart';
import 'package:fixmycar_client/src/providers/store_item_category_provider.dart';
import 'package:fixmycar_client/src/providers/store_item_provider.dart';
import 'package:fixmycar_client/src/screens/order_history_screen.dart';
import 'package:fixmycar_client/src/widgets/shop_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'master_screen.dart';

class StoreItemsScreen extends StatefulWidget {
  final User carPartsShop;

  const StoreItemsScreen({super.key, required this.carPartsShop});

  @override
  _StoreItemsScreenState createState() => _StoreItemsScreenState();
}

class _StoreItemsScreenState extends State<StoreItemsScreen> {
  late String carPartsShopFilter;
  late int carPartsShopId;
  late List<StoreItem> loadedItems;
  late User carPartsShopDetails;

  @override
  void initState() {
    super.initState();

    carPartsShopFilter = widget.carPartsShop.username;
    carPartsShopId = widget.carPartsShop.id;
    carPartsShopDetails = widget.carPartsShop;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<StoreItemProvider>(context, listen: false)
          .getStoreItems(carPartsShopName: carPartsShopFilter);

      await _fetchCarModelsAndCategories();
      await _fetchDiscounts();
    });
  }

  String _selectedDiscountFilter = 'all';
  String _filterName = '';
  bool _isFilterApplied = false;
  int? _categoryIdFilter;
  List<CarModel> _selectedCarModelsFilter = [];
  List<StoreItemCategory> _categories = [];
  List<CarModelsByManufacturer> _carModelsByManufacturer = [];
  TextEditingController _nameFilterController = TextEditingController();
  List<CarPartsShopDiscount> _discounts = [];

  List<StoreItemOrder> orderedItems = [];
  bool useProfileAddress = true;
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();

  TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _fetchDiscounts() async {
    final discountProvider =
        Provider.of<CarPartsShopDiscountProvider>(context, listen: false);
    await discountProvider.getByClient(carPartsShop: carPartsShopFilter);
    setState(() {
      _discounts = discountProvider.discounts;
    });
  }

  String _loadTotalAmount() {
    if (orderedItems.isNotEmpty) {
      double totalAmount = 0;
      for (var item in orderedItems) {
        StoreItem itemDetails = loadedItems
            .firstWhere((loadedItem) => loadedItem.id == item.storeItemId);
        double itemAmount = itemDetails.discountedPrice * item.quantity;
        totalAmount = totalAmount + itemAmount;
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
          return "$discountedTotal€";
        } else {
          return "$totalAmount€";
        }
      } else {
        return "$totalAmount€";
      }
    } else {
      return "Unknown";
    }
  }

  void _openShoppingCartForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Your Cart', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 16.0),
                    if (orderedItems.isEmpty) ...[
                      const Text('No items in your cart.')
                    ] else ...[
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: orderedItems.length,
                          itemBuilder: (context, index) {
                            final order = orderedItems[index];
                            final storeItemName =
                                'Item ${loadedItems.firstWhere((item) => item.id == order.storeItemId).name}';
                            return ListTile(
                              leading: loadedItems
                                          .firstWhere((item) =>
                                              item.id == order.storeItemId)
                                          .imageData !=
                                      ""
                                  ? Image.memory(
                                      base64Decode(loadedItems
                                          .firstWhere((item) =>
                                              item.id == order.storeItemId)
                                          .imageData!),
                                      fit: BoxFit.contain,
                                      width: 50,
                                      height: 50,
                                    )
                                  : const Icon(Icons.image, size: 50),
                              title: Text(storeItemName),
                              subtitle: Text('Quantity: ${order.quantity}'),
                            );
                          },
                        ),
                      ),
                      Text("Total amount: ${_loadTotalAmount()}"),
                    ],
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        const Text('Use profile address'),
                        Switch(
                          value: useProfileAddress,
                          onChanged: (bool value) {
                            setState(() {
                              useProfileAddress = value;
                            });
                          },
                        ),
                      ],
                    ),
                    if (!useProfileAddress) ...[
                      TextField(
                        controller: cityController,
                        decoration: const InputDecoration(labelText: 'City'),
                      ),
                      TextField(
                        controller: addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                      ),
                      TextField(
                        controller: postalCodeController,
                        decoration:
                            const InputDecoration(labelText: 'Postal Code'),
                      ),
                    ],
                    const SizedBox(height: 16.0),
                    const Text('Enter Card Details'),
                    stripe.CardField(
                      onCardChanged: (card) {
                        print(card);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
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
                          child: const Text('Discard Order'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(18, 255, 255, 255),
                          ),
                          onPressed: orderedItems.isNotEmpty
                              ? () {
                                  _confirmPlaceOrder(context);
                                }
                              : null,
                          child: const Text('Place Order'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
                  orderedItems.clear();
                  cityController.clear();
                  addressController.clear();
                  postalCodeController.clear();
                });
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

  Future<void> _confirmPlaceOrder(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Place Order'),
          content: const Text('Are you sure you want to place this order?'),
          actions: [
            TextButton(
              onPressed: () async {
                OrderInsertUpdate newOrder;
                if (useProfileAddress) {
                  newOrder = OrderInsertUpdate(carPartsShopId,
                      useProfileAddress, "", "", "", orderedItems);
                } else {
                  newOrder = OrderInsertUpdate(
                      carPartsShopId,
                      useProfileAddress,
                      cityController.text,
                      addressController.text,
                      postalCodeController.text,
                      orderedItems);
                }
                bool validateInputs = cityController.text.trim().isNotEmpty &&
                    addressController.text.trim().isNotEmpty &&
                    postalCodeController.text.trim().isNotEmpty;
                if (useProfileAddress ||
                    (!useProfileAddress && validateInputs)) {
                  try {
                    await Provider.of<OrderProvider>(context, listen: false)
                        .insertOrder(newOrder)
                        .then((_) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      setState(() {
                        orderedItems.clear();
                        cityController.clear();
                        addressController.clear();
                        postalCodeController.clear();
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderHistoryScreen(),
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
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please provide shipping details!"),
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

  int getItemQuantity(int storeItemId) {
    return orderedItems
        .firstWhere((order) => order.storeItemId == storeItemId,
            orElse: () => StoreItemOrder(storeItemId, 0))
        .quantity;
  }

  void updateItemQuantity(int storeItemId, int quantity) {
    setState(() {
      if (quantity > 0) {
        final existingOrder = orderedItems.firstWhere(
            (order) => order.storeItemId == storeItemId,
            orElse: () => StoreItemOrder(storeItemId, 0));
        if (existingOrder.quantity == 0) {
          orderedItems.add(StoreItemOrder(storeItemId, quantity));
        } else {
          existingOrder.quantity = quantity;
        }
      } else {
        orderedItems.removeWhere((order) => order.storeItemId == storeItemId);
      }
    });
  }

  Future<void> _fetchCarModelsAndCategories() async {
    final categoriesProvider =
        Provider.of<StoreItemCategoryProvider>(context, listen: false);
    await categoriesProvider.getCategories();
    setState(() {
      _categories = categoriesProvider.categories;
    });

    final carModelsByManufacturerProvider =
        Provider.of<CarModelsByManufacturerProvider>(context, listen: false);
    await carModelsByManufacturerProvider.getCarModelsByManufacturer();
    setState(() {
      _carModelsByManufacturer =
          carModelsByManufacturerProvider.modelsByManufacturer;
    });
  }

  void _showDetailsDialog(BuildContext context, StoreItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            item.name,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: double.infinity,
              ),
              child: Column(
                children: [
                  if (item.imageData != null && item.imageData!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(
                          base64Decode(item.imageData!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  _buildDetailRow(
                      'Price', '${item.price.toStringAsFixed(2)}€', context),
                  if (item.discount != 0)
                    _buildDetailRow('Discount',
                        '${(item.discount * 100).toInt()}%', context),
                  if (item.discount != 0)
                    _buildDetailRow(
                      'Discounted Price',
                      '${item.discountedPrice.toStringAsFixed(2)}€',
                      context,
                    ),
                  _buildDetailRow(
                      'Category', item.category ?? "Unknown", context),
                  _buildDetailRow(
                    'Details',
                    item.details ?? "No details available",
                    context,
                  ),
                  _buildDetailRow(
                    'Car Models',
                    item.carModels != null && item.carModels!.isNotEmpty
                        ? item.carModels!
                            .map(
                                (model) => '${model.name} (${model.modelYear})')
                            .join(', ')
                        : "Unknown",
                    context,
                  ),
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
        child: Consumer<StoreItemProvider>(
          builder: (context, provider, child) {
            loadedItems = provider.items;
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
                              context, carPartsShopDetails, null, _discounts);
                        },
                        label: const Text("Shop details"),
                      ),
                    ],
                  ),
                ),
                if (provider.isLoading)
                  const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                else if (provider.items.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(_isFilterApplied
                          ? 'No results found for your search.'
                          : 'No items available.'),
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
                        childAspectRatio: 0.55,
                      ),
                      itemCount: provider.items.length,
                      itemBuilder: (context, index) {
                        final StoreItem item = provider.items[index];
                        int quantity = getItemQuantity(item.id);

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
                                    child: item.imageData != ""
                                        ? Image.memory(
                                            base64Decode(item.imageData!),
                                            fit: BoxFit.contain,
                                            width: 400,
                                            height: 400,
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
                                  item.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      if (item.discount != 0) ...[
                                        TextSpan(
                                          text: '${item.price}€ ',
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.red,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' ${item.discountedPrice}€',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ] else ...[
                                        TextSpan(
                                          text: '${item.price}€',
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
                              if (item.discount != 0)
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    'Discount: ${(item.discount * 100).toInt()}%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  'Category: ${item.category == "" ? "Unknown" : item.category}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  'Car models: ${item.carModels?.isNotEmpty == true ? item.carModels!.map((model) => model.name).join(", ") : "Unknown"}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: quantity > 0
                                          ? () => updateItemQuantity(
                                              item.id, quantity - 1)
                                          : null,
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Text('$quantity',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                    IconButton(
                                      onPressed: () => updateItemQuantity(
                                          item.id, quantity + 1),
                                      icon: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).highlightColor,
                                  ),
                                  onPressed: () {
                                    _showDetailsDialog(context, item);
                                  },
                                  child: const Text('Details'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openShoppingCartForm(context),
        backgroundColor: Theme.of(context).hoverColor,
        child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    _nameFilterController.text = _filterName;
    CarManufacturer? selectedManufacturer;
    CarModel? selectedModel;

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
                    DropdownButton<int>(
                      value: _categoryIdFilter,
                      onChanged: (int? newValue) {
                        setState(() {
                          _categoryIdFilter = newValue;
                        });
                      },
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text('All'),
                        ),
                        ..._categories.map<DropdownMenuItem<int>>(
                            (StoreItemCategory category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                      ],
                      isExpanded: true,
                      hint: const Text('Select a category'),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<CarManufacturer>(
                      value: selectedManufacturer,
                      onChanged: (CarManufacturer? newValue) {
                        setState(() {
                          selectedManufacturer = newValue;
                          selectedModel = null;
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
                    if (selectedManufacturer != null)
                      const SizedBox(height: 20),
                    if (selectedManufacturer != null)
                      DropdownButton<CarModel>(
                        value: selectedModel,
                        onChanged: (CarModel? newValue) {
                          setState(() {
                            if (newValue != null) {
                              bool alreadyExists = _selectedCarModelsFilter
                                  .any((model) => model.id == newValue.id);
                              if (!alreadyExists) {
                                selectedModel = newValue;
                                _selectedCarModelsFilter.add(newValue);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Model already selected'),
                                  ),
                                );
                              }
                            }
                          });
                        },
                        items: _carModelsByManufacturer
                            .firstWhere((cm) =>
                                cm.manufacturer == selectedManufacturer!)
                            .models
                            .map<DropdownMenuItem<CarModel>>((CarModel model) {
                          return DropdownMenuItem<CarModel>(
                            value: model,
                            child: Text('${model.name} (${model.modelYear})'),
                          );
                        }).toList(),
                        isExpanded: true,
                        hint: const Text('Select a model'),
                      ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _selectedCarModelsFilter.map((CarModel model) {
                        return FilterChip(
                          label: Text('${model.name} (${model.modelYear})'),
                          onSelected: (bool selected) {
                            setState(() {
                              if (!selected) {
                                _selectedCarModelsFilter.remove(model);
                              }
                            });
                          },
                          selected: true,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                Center(
                  child: TextButton(
                    child: const Text('Apply Filters'),
                    onPressed: () {
                      _applyFilters();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _applyFilters() {
    final provider = Provider.of<StoreItemProvider>(context, listen: false);
    bool? discountFilter;
    List<int> carModels;

    if (_selectedDiscountFilter == 'discounted') {
      discountFilter = true;
    } else if (_selectedDiscountFilter == 'non-discounted') {
      discountFilter = false;
    }
    carModels = _selectedCarModelsFilter.map((model) => model.id).toList();

    setState(() {
      _isFilterApplied = true;
    });

    provider.getStoreItems(
        carPartsShopName: carPartsShopFilter,
        nameFilter: _filterName.isNotEmpty ? _filterName : null,
        withDiscount: discountFilter,
        categoryFilter: _categoryIdFilter,
        carModelsFilter: carModels);
  }

  @override
  void dispose() {
    _nameFilterController.dispose();
    super.dispose();
  }
}
