import 'package:fixmycar_car_repair_shop/src/models/car_manufacturer/car_manufacturer.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_model/car_model.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_model/car_models_by_manufacturer.dart';
import 'package:fixmycar_car_repair_shop/src/models/store_item/store_item.dart';
import 'package:fixmycar_car_repair_shop/src/models/store_item/store_item_order.dart';
import 'package:fixmycar_car_repair_shop/src/models/store_item_category/store_item_category.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_models_by_manufacturer_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/store_item_category_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/store_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'master_screen.dart';

class StoreItemsScreen extends StatefulWidget {
  final String carPartsShop;

  const StoreItemsScreen({super.key, required this.carPartsShop});

  @override
  _StoreItemsScreenState createState() => _StoreItemsScreenState();
}

class _StoreItemsScreenState extends State<StoreItemsScreen> {

  late String carPartsShopFilter;

  @override
  void initState() {
    super.initState();

    carPartsShopFilter = widget.carPartsShop;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<StoreItemProvider>(context, listen: false).getStoreItems(carPartsShopName: carPartsShopFilter);
      await _fetchCarModelsAndCategories();
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

  List<StoreItemOrder> orderedItems = [];

  int getItemQuantity(int storeItemId) {
    return orderedItems
        .firstWhere((order) => order.storeItemId == storeItemId, orElse: () => StoreItemOrder(storeItemId, 0))
        .quantity;
  }

  void updateItemQuantity(int storeItemId, int quantity) {
    setState(() {
      if (quantity > 0) {
        final existingOrder = orderedItems.firstWhere((order) => order.storeItemId == storeItemId, orElse: () => StoreItemOrder(storeItemId, 0));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MasterScreen(
        showBackButton: true,
        child: Consumer<StoreItemProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.filter_list,
                          color: Theme.of(context).primaryColorLight),
                      onPressed: () => _showFilterDialog(context),
                    ),
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
                        childAspectRatio: 0.9,
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
                                            width: 200,
                                            height: 200,
                                          )
                                        : const SizedBox(
                                            width: 200,
                                            height: 200,
                                            child: Icon(Icons.image, size: 150),
                                          ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                  padding: const EdgeInsets.all(8.0),
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Category: ${item.category == "" ? "Unknown" : item.category}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Car models: ${item.carModels?.isNotEmpty == true ? item.carModels!.map((model) => model.name).join(', ') : "Unknown"}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: quantity > 0 ? () => updateItemQuantity(item.id, quantity - 1) : null,
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Text('$quantity', style: Theme.of(context).textTheme.bodyLarge),
                                    IconButton(
                                      onPressed: () => updateItemQuantity(item.id, quantity + 1),
                                      icon: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    //TODO: Implement the logic for the details button
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
        onPressed: () {
          //TODO: Shopping cart
        },
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
