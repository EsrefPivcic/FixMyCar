import 'package:fixmycar_car_repair_shop/constants.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_model/car_model.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_model/car_models_by_manufacturer.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_parts_shop_discount/car_parts_shop_discount.dart';
import 'package:fixmycar_car_repair_shop/src/models/city/city.dart';
import 'package:fixmycar_car_repair_shop/src/models/order/order_insert_update.dart';
import 'package:fixmycar_car_repair_shop/src/models/store_item/store_item.dart';
import 'package:fixmycar_car_repair_shop/src/models/store_item/store_item_order.dart';
import 'package:fixmycar_car_repair_shop/src/models/store_item_category/store_item_category.dart';
import 'package:fixmycar_car_repair_shop/src/models/user/user.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_models_by_manufacturer_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_parts_shop_discount_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/city_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/order_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/recommender_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/store_item_category_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/store_item_provider.dart';
import 'package:fixmycar_car_repair_shop/src/screens/order_history_screen.dart';
import 'package:fixmycar_car_repair_shop/src/utilities/card_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  List<City>? _cities;
  int? _selectedCity;
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
          pageNumber: _pageNumber,
          pageSize: _pageSize,
          carPartsShopName: carPartsShopFilter);

      await _fetchCarModelsAndCategories();
      await _fetchDiscounts();
      await _fetchCities();
    });
  }

  String _selectedDiscountFilter = 'all';
  String _filterName = '';
  bool _isFilterApplied = false;
  int? _categoryIdFilter;
  int? _selectedManufacturerId;
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

  String selectedCard = 'pm_card_visa_chargeDeclined';
  String? cardNumber;
  String? expirationDate;
  String? cvv;

  Future _fetchCities() async {
    if (mounted) {
      var cityProvider = Provider.of<CityProvider>(context, listen: false);
      await cityProvider.getCities().then((_) {
        setState(() {
          _cities = cityProvider.cities;
          _selectedCity = _cities![0].id;
        });
      });
    }
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

  void _getCard() {
    //flutter_stripe not supported for desktop
    if (cardNumber == '4242 4242 4242 4242') {
      setState(() {
        selectedCard = 'pm_card_visa';
      });
    } else {
      setState(() {
        selectedCard = 'pm_card_visa_chargeDeclined';
      });
    }
  }

  void _openShoppingCartForm(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: SizedBox(
                  width: 500,
                  child: Form(
                    key: _formKey,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.90,
                      ),
                      child: SingleChildScrollView(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          const Text('Your Cart',
                              style: TextStyle(fontSize: 24)),
                          const SizedBox(height: 16.0),
                          if (orderedItems.isEmpty) ...[
                            const Text('No items in your cart.')
                          ] else ...[
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: orderedItems.length,
                                itemBuilder: (context, index) {
                                  final order = orderedItems[index];
                                  final storeItemName = orderedItemsDetails
                                      .firstWhere((item) =>
                                          item.id == order.storeItemId)
                                      .name;
                                  return ListTile(
                                    leading: orderedItemsDetails
                                                .firstWhere((item) =>
                                                    item.id ==
                                                    order.storeItemId)
                                                .imageData !=
                                            ""
                                        ? Image.memory(
                                            base64Decode(orderedItemsDetails
                                                .firstWhere((item) =>
                                                    item.id ==
                                                    order.storeItemId)
                                                .imageData!),
                                            fit: BoxFit.contain,
                                            width: 200,
                                            height: 200,
                                          )
                                        : const SizedBox(
                                            width: 200,
                                            height: 200,
                                            child: Icon(Icons.image, size: 50),
                                          ),
                                    title: Text(storeItemName),
                                    subtitle:
                                        Text('Quantity: ${order.quantity}'),
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
                            if (_cities != null && _cities!.isNotEmpty) ...[
                              const SizedBox(height: 10.0),
                              DropdownButtonFormField<int>(
                                value: _selectedCity,
                                items: _cities!.map((City city) {
                                  return DropdownMenuItem<int>(
                                    value: city.id,
                                    child: Text(city.name),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCity = newValue;
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
                                  if (value == null) {
                                    return AppConstants.cityError;
                                  }
                                  return null;
                                },
                              ),
                            ],
                            TextFormField(
                                controller: addressController,
                                decoration: const InputDecoration(
                                    labelText: 'Shipping Address'),
                                keyboardType: TextInputType.number,
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
                          const Text('Choose a Card (Visa only)'),
                          Column(
                            children: [
                              //flutter_stripe not supported for desktop
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Card Number',
                                  hintText: '1234 1234 1234 1234',
                                ),
                                inputFormatters: [
                                  CardNumberFormatter(),
                                  LengthLimitingTextInputFormatter(19),
                                ],
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  setState(() {
                                    cardNumber = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length != 19) {
                                    return 'Please enter a valid card number';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Expiration Date',
                                  hintText: 'MM/YY',
                                ),
                                inputFormatters: [
                                  ExpirationDateFormatter(),
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                keyboardType: TextInputType.datetime,
                                onSaved: (value) {
                                  setState(() {
                                    expirationDate = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length != 5) {
                                    return 'Please enter a valid expiration date';
                                  }

                                  final regex = RegExp(r'^\d{2}/\d{2}$');
                                  if (!regex.hasMatch(value)) {
                                    return 'Please enter a valid expiration date in MM/YY format';
                                  }

                                  final month =
                                      int.tryParse(value.substring(0, 2));
                                  final year =
                                      int.tryParse(value.substring(3, 5));

                                  if (month == null || year == null) {
                                    return 'Invalid month or year';
                                  }

                                  if (month < 1 || month > 12) {
                                    return 'Please enter a valid month (01-12)';
                                  }

                                  final currentYear = DateTime.now().year;
                                  final currentYearLastTwoDigits =
                                      currentYear % 100;

                                  if (year < currentYearLastTwoDigits) {
                                    return 'Expiration date must be any future date';
                                  }

                                  if (year == currentYearLastTwoDigits) {
                                    final currentMonth = DateTime.now().month;

                                    if (month <= currentMonth) {
                                      return 'Expiration date must be any future date';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'CVV',
                                  hintText: '***',
                                ),
                                inputFormatters: [
                                  CVVFormatter(),
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                onSaved: (value) {
                                  setState(() {
                                    cvv = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length != 3) {
                                    return 'Please enter a valid CVV';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        18, 255, 255, 255)),
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        18, 255, 255, 255)),
                                onPressed: () => _confirmDiscard(context),
                                child: const Text('Discard Order'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        18, 255, 255, 255)),
                                onPressed: orderedItems.isNotEmpty
                                    ? () {
                                        if ((_formKey.currentState
                                                ?.validate() ??
                                            false)) {
                                          _formKey.currentState!.save();
                                          _getCard();
                                          _confirmPlaceOrder(
                                              context, selectedCard);
                                        }
                                      }
                                    : null,
                                child: const Text('Place Order'),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  )),
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
                  _selectedCity = _cities![0].id;
                });
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

  Future<void> _confirmPlaceOrder(BuildContext context, String card) async {
    bool working = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
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
                    setDialogState(() {
                      working = true;
                    });
                    OrderInsertUpdate newOrder;
                    if (useProfileAddress) {
                      newOrder = OrderInsertUpdate(carPartsShopId,
                          useProfileAddress, null, null, null, orderedItems);
                    } else {
                      newOrder = OrderInsertUpdate(
                          carPartsShopId,
                          useProfileAddress,
                          _selectedCity,
                          addressController.text,
                          postalCodeController.text,
                          orderedItems);
                    }
                    try {
                      await Provider.of<OrderProvider>(context, listen: false)
                          .insertOrder(newOrder, card)
                          .then((_) {
                        setState(() {
                          orderedItems = [];
                          orderedItemsDetails = [];
                          cityController.clear();
                          addressController.clear();
                          postalCodeController.clear();
                          _selectedCity = _cities![0].id;
                        });
                      }).then((_) {
                        Navigator.pop(context);
                        Navigator.pop(context);
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
        Provider.of<RecommenderProvider>(context, listen: false);

    await recommenderProvider.getRecommendations(storeItemId: item.id);
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
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
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
                          width: 200,
                          height: 200,
                          child: Icon(Icons.image, size: 120),
                        ),
                      )
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
    return Scaffold(
      body: MasterScreen(
        showBackButton: true,
        child: Consumer<StoreItemProvider>(
          builder: (context, provider, child) {
            loadedItems = provider.items;
            if (!provider.isLoading) {
              _totalPages = (provider.countOfItems / _pageSize).ceil();
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.info_outline_rounded),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(18, 255, 255, 255)),
                        onPressed: () {
                          showShopDetailsDialog(context);
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
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.8,
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
                                    child: Container(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  height: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: item.imageData != ""
                                        ? Image.memory(
                                            base64Decode(item.imageData!),
                                            fit: BoxFit.cover,
                                          )
                                        : const SizedBox(
                                            child: Icon(Icons.image, size: 120),
                                          ),
                                  ),
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  item.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
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
                                  padding: const EdgeInsets.only(bottom: 5.0),
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
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Car models: ${item.carModels?.isNotEmpty == true ? item.carModels!.map((model) => model.name).join(', ') : "Unknown"}',
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
                if (provider.items.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _pageNumber > 1
                            ? () {
                                setState(() {
                                  _pageNumber = _pageNumber - 1;
                                  _applyFiltersPaged();
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
                                _applyFiltersPaged();
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
      floatingActionButton: FloatingActionButton(
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
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Filter by Name'),
                      TextField(
                        decoration:
                            const InputDecoration(hintText: 'Enter name'),
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
                          ..._carModelsByManufacturer
                              .map<DropdownMenuItem<int>>(
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
                              .map<DropdownMenuItem<CarModel>>(
                                  (CarModel model) {
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
                        children:
                            _selectedCarModelsFilter.map((CarModel model) {
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
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Apply Filters'),
                  onPressed: () {
                    _applyFilters();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _applyFiltersPaged() {
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
        pageNumber: _pageNumber,
        pageSize: _pageSize,
        carPartsShopName: carPartsShopFilter,
        nameFilter: _filterName.isNotEmpty ? _filterName : null,
        withDiscount: discountFilter,
        carManufacturerId: _selectedManufacturerId,
        categoryFilter: _categoryIdFilter,
        carModelsFilter: carModels);
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

    setState(() {
      _pageNumber = 1;
    });

    provider.getStoreItems(
        pageNumber: _pageNumber,
        pageSize: _pageSize,
        carPartsShopName: carPartsShopFilter,
        nameFilter: _filterName.isNotEmpty ? _filterName : null,
        withDiscount: discountFilter,
        carManufacturerId: _selectedManufacturerId,
        categoryFilter: _categoryIdFilter,
        carModelsFilter: carModels);
  }

  @override
  void dispose() {
    _nameFilterController.dispose();
    _pageNumber = 1;
    super.dispose();
  }

  void showShopDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.35,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    carPartsShopDetails.username,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (carPartsShopDetails.image != null)
                    Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      height: 150,
                      child: carPartsShopDetails.image != ""
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                base64Decode(carPartsShopDetails.image!),
                                fit: BoxFit.cover,
                                height: 100,
                              ),
                            )
                          : Icon(Icons.image,
                              size: 80, color: Colors.grey[400]),
                    ),
                  _buildProfileDetailRow(
                      'Owner',
                      "${carPartsShopDetails.name} ${carPartsShopDetails.surname}",
                      context),
                  _buildProfileDetailRow(
                      'City', carPartsShopDetails.city, context),
                  _buildProfileDetailRow(
                    'Address',
                    carPartsShopDetails.address,
                    context,
                  ),
                  _buildProfileDetailRow(
                      'Phone', carPartsShopDetails.phone, context),
                  _buildProfileDetailRow(
                      'Email', carPartsShopDetails.email, context),
                  _buildProfileDetailRow(
                    'Work Time',
                    '${_parseTimeOfDay(carPartsShopDetails.openingTime).format(context)} - ${_parseTimeOfDay(carPartsShopDetails.closingTime).format(context)}',
                    context,
                  ),
                  _buildProfileDetailRow(
                    'Work Days',
                    carPartsShopDetails.workDays
                        .map((day) => day.substring(0, 3))
                        .join(', '),
                    context,
                  ),
                  if (_discounts.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Personal Discounts',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    for (var discount in _discounts)
                      _buildDiscountRow(discount, context),
                  ],
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscountRow(
      CarPartsShopDiscount discount, BuildContext context) {
    bool isActive = discount.revoked == null;
    String statusText = isActive
        ? "Active"
        : "Revoked on ${_formatDate(discount.revoked.toString())}";
    Color statusColor = isActive ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discount: ${(discount.value * 100).toInt()}%',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Created: ${_formatDate(discount.created.toString())}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                statusText,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: statusColor),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  String _formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  Widget _buildProfileDetailRow(
      String title, String value, BuildContext context) {
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
}
