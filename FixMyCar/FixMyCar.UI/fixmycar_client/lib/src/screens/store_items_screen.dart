import 'package:fixmycar_client/constants.dart';
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
import 'package:fixmycar_client/src/providers/city_provider.dart';
import 'package:fixmycar_client/src/providers/order_provider.dart';
import 'package:fixmycar_client/src/providers/items_recommender_provider.dart';
import 'package:fixmycar_client/src/providers/store_item_category_provider.dart';
import 'package:fixmycar_client/src/providers/store_item_provider.dart';
import 'package:fixmycar_client/src/screens/car_parts_shops_screen.dart';
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
  List<String>? _cities;
  int? _selectedManufacturerId;
  String? _selectedCity;
  int _pageNumber = 1;
  final int _pageSize = 10;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();

    carPartsShopFilter = widget.carPartsShop.username;
    carPartsShopId = widget.carPartsShop.id;
    carPartsShopDetails = widget.carPartsShop;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<StoreItemProvider>(context, listen: false).getStoreItems(
          carPartsShopName: carPartsShopFilter,
          pageNumber: _pageNumber,
          pageSize: _pageSize);

      await _fetchCarModelsAndCategories();
      await _fetchDiscounts();
      await _fetchCities();
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
  late List<StoreItem> recommendedItems;

  List<StoreItemOrder> orderedItems = [];
  List<StoreItem> orderedItemsDetails = [];
  bool useProfileAddress = true;
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();

  Future _fetchCities() async {
    if (mounted) {
      var cityProvider = Provider.of<CityProvider>(context, listen: false);
      await cityProvider.getCities().then((_) {
        setState(() {
          _cities = cityProvider.cities.map((city) => city.name).toList();
          _cities!.add("Custom");
          _selectedCity = _cities![0];
        });
      });
    }
  }

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
        StoreItem itemDetails = orderedItemsDetails
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
          return "${discountedTotal.toStringAsFixed(2)}€";
        } else {
          return "${totalAmount.toStringAsFixed(2)}€";
        }
      } else {
        return "${totalAmount.toStringAsFixed(2)}€";
      }
    } else {
      return "Unknown";
    }
  }

  void _openShoppingCartForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    bool isCardValid = false;
    bool cardError = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                right: 10,
                left: 10,
                top: 10,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
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
                                    'Item ${orderedItemsDetails.firstWhere((item) => item.id == order.storeItemId).name}';
                                return ListTile(
                                  leading: orderedItemsDetails
                                              .firstWhere((item) =>
                                                  item.id == order.storeItemId)
                                              .imageData !=
                                          ""
                                      ? Image.memory(
                                          base64Decode(orderedItemsDetails
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
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Total amount: ${_loadTotalAmount()}"),
                        ],
                        const SizedBox(height: 16.0),
                        const Text('Enter Card Details'),
                        stripe.CardField(
                          onCardChanged: (card) {
                            setState(() {
                              isCardValid = card!.complete;
                              if (card.complete) {
                                cardError = false;
                              }
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (!isCardValid && cardError) ...[
                          const SizedBox(height: 5.0),
                          Text(
                            "Please insert card details",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
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
                          if (_cities != null && _cities!.isNotEmpty) ...[
                            const SizedBox(height: 10.0),
                            DropdownButtonFormField<String>(
                              value: _selectedCity,
                              items: _cities!.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCity = newValue!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: AppConstants.cityLabel,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppRadius.textFieldRadius),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppConstants.cityError;
                                }
                                return null;
                              },
                            ),
                          ],
                          if (_selectedCity == 'Custom' ||
                              (_cities == null || _cities!.isEmpty)) ...[
                            TextFormField(
                                controller: cityController,
                                decoration: const InputDecoration(
                                    labelText: 'Custom City'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a city name";
                                  }
                                  if (num.tryParse(value) is num) {
                                    return "City names can't be numeric";
                                  }
                                  if (value.length > 25) {
                                    return "City names can't be longer than 25 characters";
                                  }
                                  return null;
                                }),
                          ],
                          TextFormField(
                              controller: addressController,
                              decoration: const InputDecoration(
                                  labelText: 'Shipping Address'),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a shipping address";
                                }
                                if (num.tryParse(value) is num) {
                                  return "Shipping address can't be numeric";
                                }
                                if (value.length > 30) {
                                  return "Shipping address can't be longer than 30 characters";
                                }
                                return null;
                              }),
                          TextFormField(
                              controller: postalCodeController,
                              decoration: const InputDecoration(
                                  labelText: 'Shipping Postal Code'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a postal code";
                                }
                                if (value.length > 15) {
                                  return "Shipping address can't be longer than 15 characters";
                                }
                                return null;
                              }),
                        ],
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
                              child: const Text('Discard'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(18, 255, 255, 255),
                              ),
                              onPressed: orderedItems.isNotEmpty
                                  ? () {
                                      if (useProfileAddress) {
                                        if (isCardValid) {
                                          _confirmPlaceOrder(context);
                                        } else {
                                          setState(() {
                                            cardError = true;
                                          });
                                        }
                                      } else {
                                        if ((formKey.currentState?.validate() ??
                                            false)) {
                                          if (isCardValid) {
                                            _confirmPlaceOrder(context);
                                          } else {
                                            setState(() {
                                              cardError = true;
                                            });
                                          }
                                        }
                                      }
                                    }
                                  : null,
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
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
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  orderedItems.clear();
                  orderedItemsDetails.clear();
                  cityController.clear();
                  addressController.clear();
                  postalCodeController.clear();
                  _selectedCity = _cities![0];
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Discard successful!"),
                  ),
                );
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmPlaceOrder(BuildContext context) async {
    bool working = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Place Order'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Are you sure you want to place this order?'),
                    const SizedBox(
                      height: 10,
                    ),
                    if (working)
                      const SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator()),
                  ]),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      working = true;
                    });
                    OrderInsertUpdate newOrder;
                    if (useProfileAddress) {
                      newOrder = OrderInsertUpdate(carPartsShopId,
                          useProfileAddress, "", "", "", orderedItems);
                    } else {
                      newOrder = OrderInsertUpdate(
                          carPartsShopId,
                          useProfileAddress,
                          useProfileAddress
                              ? ""
                              : _selectedCity == 'Custom'
                                  ? cityController.text
                                  : _selectedCity!,
                          addressController.text,
                          postalCodeController.text,
                          orderedItems);
                    }
                    bool validateCityInput =
                        (cityController.text.trim().isNotEmpty &&
                                _selectedCity == "Custom") ||
                            (_selectedCity != null &&
                                _selectedCity!.isNotEmpty &&
                                _selectedCity != "Custom");
                    bool validateInputs = validateCityInput &&
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
                            orderedItemsDetails.clear();
                            cityController.clear();
                            addressController.clear();
                            postalCodeController.clear();
                            _selectedCity = _cities![0];
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Order processed!"),
                            ),
                          );
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
              ],
            );
          },
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
          orderedItemsDetails
              .add(loadedItems.firstWhere((item) => item.id == storeItemId));
        } else {
          existingOrder.quantity = quantity;
        }
      } else {
        orderedItems.removeWhere((order) => order.storeItemId == storeItemId);
        orderedItemsDetails.removeWhere((item) => item.id == storeItemId);
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

  void _showDetailsDialog(BuildContext context, StoreItem item) async {
    final recommenderProvider =
        Provider.of<ItemsRecommenderProvider>(context, listen: false);

    await recommenderProvider.getStoreItemRecommendations(storeItemId: item.id);
    recommendedItems = recommenderProvider.recommendedItems;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            item.name,
            style: Theme.of(dialogContext).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: double.infinity),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.imageData != null) ...[
                    if (item.imageData != "")
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
                      )
                    else
                      Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        height: 150,
                        child: const SizedBox(
                          width: 150,
                          height: 150,
                          child: Icon(Icons.image, size: 90),
                        ),
                      ),
                  ],
                  _buildDetailRow('Price', '${item.price.toStringAsFixed(2)}€',
                      dialogContext),
                  if (item.discount != 0)
                    _buildDetailRow(
                        'Discount',
                        '${(item.discount * 100).toStringAsFixed(2)}%',
                        dialogContext),
                  if (item.discount != 0)
                    _buildDetailRow(
                      'Discounted Price',
                      '${item.discountedPrice.toStringAsFixed(2)}€',
                      dialogContext,
                    ),
                  _buildDetailRow(
                      'Category', item.category ?? "Unknown", dialogContext),
                  _buildDetailRow(
                    'Details',
                    item.details ?? "No details available",
                    dialogContext,
                  ),
                  _buildDetailRow(
                    'Car Models',
                    item.carModels != null && item.carModels!.isNotEmpty
                        ? item.carModels!
                            .map(
                                (model) => '${model.name} (${model.modelYear})')
                            .join(', ')
                        : "Unknown",
                    dialogContext,
                  ),
                  if (recommenderProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (recommenderProvider.recommendedItems.isEmpty)
                    const Center(child: Text('No recommendations.'))
                  else ...[
                    const SizedBox(height: 10),
                    Text("Users who buy ${item.name}, also buy:"),
                    const SizedBox(height: 5),
                    Column(
                      children: List.generate(recommendedItems.length, (index) {
                        final recommendedItem = recommendedItems[index];
                        return ListTile(
                          onTap: () async {
                            Navigator.of(dialogContext).pop();
                            await Future.delayed(
                                const Duration(milliseconds: 150));
                            _showDetailsDialog(context, recommendedItem);
                          },
                          leading: recommendedItem.imageData != ""
                              ? Image.memory(
                                  base64Decode(recommendedItem.imageData!),
                                  fit: BoxFit.contain,
                                  width: 50,
                                  height: 50,
                                )
                              : const Icon(Icons.image, size: 50),
                          title: Text(recommendedItem.name),
                        );
                      }),
                    ),
                  ]
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
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
      body: Stack(
        children: [
          MasterScreen(
            child: Consumer<StoreItemProvider>(
              builder: (context, provider, child) {
                if (!provider.isLoading) {
                  _totalPages = (provider.countOfItems / _pageSize).ceil();
                }
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
                              showShopDetailsDialog(context,
                                  carPartsShopDetails, null, _discounts);
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                        padding: const EdgeInsets.all(5.0),
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
                                                child:
                                                    Icon(Icons.image, size: 90),
                                              ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      item.name,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
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
                                              text:
                                                  '${item.price.toStringAsFixed(2)}€ ',
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.red,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  ' ${item.discountedPrice.toStringAsFixed(2)}€',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                          ] else ...[
                                            TextSpan(
                                              text:
                                                  '${item.price.toStringAsFixed(2)}€',
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
                                        'Discount: ${(item.discount * 100).toStringAsFixed(2)}%',
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
                                      'Car models: ${item.carModels?.isNotEmpty == true ? item.carModels!.map((model) => model.name).join(", ") : "Unknown"}',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 3.0,
                                        bottom: 3.0),
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
                    if (provider.items.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _pageNumber > 1
                                ? () {
                                    setState(() {
                                      _pageNumber = _pageNumber - 1;
                                      _applyFilters();
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          ),
                          Text('$_pageNumber',
                              style: Theme.of(context).textTheme.bodyLarge),
                          IconButton(
                            onPressed: _pageNumber < _totalPages
                                ? () {
                                    setState(() {
                                      _pageNumber = _pageNumber + 1;
                                    });
                                    _applyFilters();
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              heroTag: 'shopButton',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CarPartsShopsScreen(),
                  ),
                );
              },
              backgroundColor: Theme.of(context).hoverColor,
              child: const Icon(Icons.arrow_back_rounded),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'cartButton',
        onPressed: () => _openShoppingCartForm(context),
        backgroundColor: Theme.of(context).hoverColor,
        child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    _nameFilterController.text = _filterName;
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
                    const SizedBox(height: 20),
                    const Text('Category'),
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
                    const Text('Car Manufacturer'),
                    DropdownButton<int>(
                      value: _selectedCarModelsFilter.isEmpty
                          ? _selectedManufacturerId
                          : null,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedManufacturerId = newValue;
                          selectedModel = null;
                        });
                      },
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text('All'),
                        ),
                        ..._carModelsByManufacturer.map<DropdownMenuItem<int>>(
                            (CarModelsByManufacturer cm) {
                          return DropdownMenuItem<int>(
                            value: cm.manufacturer.id,
                            child: Text(cm.manufacturer.name),
                          );
                        }).toList(),
                      ],
                      isExpanded: true,
                      hint: const Text('Car Manufacturer'),
                    ),
                    if (_selectedManufacturerId != null) ...[
                      const SizedBox(height: 20),
                      const Text('Car Models'),
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
                                cm.manufacturer.id == _selectedManufacturerId)
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
                    ],
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
                                if (_selectedCarModelsFilter.isEmpty) {
                                  _selectedManufacturerId = null;
                                }
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
                      setState(() {
                        _pageNumber = 1;
                      });
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
        carModelsFilter: carModels,
        carManufacturerId: _selectedManufacturerId,
        pageNumber: _pageNumber,
        pageSize: _pageSize);
  }

  @override
  void dispose() {
    _nameFilterController.dispose();
    super.dispose();
  }
}
