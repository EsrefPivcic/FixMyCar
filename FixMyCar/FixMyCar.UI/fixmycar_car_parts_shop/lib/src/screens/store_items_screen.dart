import 'package:fixmycar_car_parts_shop/src/models/car_model/car_models_by_manufacturer.dart';
import 'package:fixmycar_car_parts_shop/src/models/car_model/car_model.dart';
import 'package:fixmycar_car_parts_shop/src/models/car_manufacturer/car_manufacturer.dart';
import 'package:fixmycar_car_parts_shop/src/models/store_item/store_item_insert_update.dart';
import 'package:fixmycar_car_parts_shop/src/models/store_item_category/store_item_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_parts_shop/src/models/store_item/store_item.dart';
import 'package:fixmycar_car_parts_shop/src/providers/store_item_provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/car_models_by_manufacturer_provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/store_item_category_provider.dart';
import 'dart:convert';
import 'master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class StoreItemsScreen extends StatefulWidget {
  const StoreItemsScreen({Key? key}) : super(key: key);

  @override
  _StoreItemsScreenState createState() => _StoreItemsScreenState();
}

class _StoreItemsScreenState extends State<StoreItemsScreen> {
  String _selectedStatusFilter = 'all';
  String _selectedDiscountFilter = 'all';
  String _filterName = '';
  bool _isFilterApplied = false;
  int? _categoryIdFilter;
  List<CarModel> _selectedCarModelsFilter = [];
  List<StoreItemCategory> _categories = [];
  List<CarModelsByManufacturer> _carModelsByManufacturer = [];
  TextEditingController _nameFilterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<StoreItemProvider>(context, listen: false).getStoreItems();
      await _fetchCarModelsAndCategories();
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
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: _buildActionButtons(item),
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
          _showEditForm(context, null, false);
        },
        backgroundColor: Theme.of(context).hoverColor,
        child: const Icon(Icons.add, color: Colors.white),
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
                    const Text('StoreItem Status'),
                    RadioListTile<String>(
                      title: const Text('Active'),
                      value: 'active',
                      groupValue: _selectedStatusFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatusFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Hidden'),
                      value: 'draft',
                      groupValue: _selectedStatusFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatusFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('All'),
                      value: 'all',
                      groupValue: _selectedStatusFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatusFilter = value!;
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
    String? stateFilter;
    bool? discountFilter;
    List<int> carModels;

    if (_selectedStatusFilter != 'all') {
      stateFilter = _selectedStatusFilter;
    }
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
        nameFilter: _filterName.isNotEmpty ? _filterName : null,
        withDiscount: discountFilter,
        state: stateFilter,
        categoryFilter: _categoryIdFilter,
        carModelsFilter: carModels);
  }

  List<Widget> _buildActionButtons(StoreItem item) {
    if (item.state == 'draft') {
      return [
        ElevatedButton(
          onPressed: () {
            _showEditForm(context, item, true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
          child: const Text('Edit'),
        ),
        ElevatedButton(
          onPressed: () async {
            bool confirmDelete = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content:
                      const Text('Are you sure you want to delete this item?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            );
            if (confirmDelete) {
              await Provider.of<StoreItemProvider>(context, listen: false)
                  .deleteStoreItem(item.id)
                  .then((_) {
                _applyFilters();
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
          child: const Text('Delete'),
        ),
        ElevatedButton(
          onPressed: () async {
            bool confirmActivate = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Activation'),
                  content: const Text(
                      'Are you sure you want to activate this item?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            );
            if (confirmActivate) {
              await Provider.of<StoreItemProvider>(context, listen: false)
                  .activate(item.id)
                  .then((_) {
                _applyFilters();
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
          child: const Text('Activate'),
        ),
      ];
    } else {
      return [
        ElevatedButton(
          onPressed: () async {
            bool confirmHide = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Hiding'),
                  content:
                      const Text('Are you sure you want to hide this item?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            );
            if (confirmHide) {
              await Provider.of<StoreItemProvider>(context, listen: false)
                  .hide(item.id)
                  .then((_) {
                _applyFilters();
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
          child: const Text('Hide'),
        ),
      ];
    }
  }

  void _showEditForm(BuildContext context, StoreItem? item, bool edit) {
    TextEditingController nameController = TextEditingController(text: "");
    TextEditingController discountController = TextEditingController(text: "0");
    TextEditingController priceController = TextEditingController(text: "0");
    TextEditingController detailsController = TextEditingController(text: "");
    String? base64Image = "";
    String? imagePath;
    int? categoryId;
    CarManufacturer? selectedManufacturer;
    CarModel? selectedModel;
    List<CarModel> selectedCarModels = [];
    StoreItemInsertUpdate newStoreItem = StoreItemInsertUpdate.n();

    if (edit) {
      nameController = TextEditingController(text: item!.name);
      discountController =
          TextEditingController(text: (item.discount * 100).toString());
      priceController = TextEditingController(text: item.price.toString());
      detailsController = TextEditingController(text: item.details);
      base64Image = item.imageData;
      categoryId = item.storeItemCategoryId;
      selectedCarModels = List.from(item.carModels ?? []);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price (€)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: discountController,
                        decoration: const InputDecoration(
                          labelText: 'Discount (%)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      DropdownButton<int>(
                        value: categoryId,
                        onChanged: (int? newValue) {
                          setState(() {
                            categoryId = newValue;
                            newStoreItem.storeItemCategoryId = newValue!;
                          });
                        },
                        items: _categories.map<DropdownMenuItem<int>>(
                            (StoreItemCategory category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
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
                                bool alreadyExists = selectedCarModels
                                    .any((model) => model.id == newValue.id);
                                if (!alreadyExists) {
                                  selectedModel = newValue;
                                  selectedCarModels.add(newValue);
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
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: selectedCarModels.map((CarModel model) {
                          return FilterChip(
                            label: Text('${model.name} (${model.modelYear})'),
                            onSelected: (bool selected) {
                              setState(() {
                                if (!selected) {
                                  selectedCarModels.remove(model);
                                }
                              });
                            },
                            selected: true,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: detailsController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Details',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (base64Image != "")
                        Image.memory(
                          base64Decode(base64Image!),
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                        )
                      else
                        const Icon(Icons.image, size: 150),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                          );
                          if (result != null) {
                            setState(() {
                              imagePath = result.files.single.path;
                              base64Image = base64Encode(
                                  File(imagePath!).readAsBytesSync());
                            });
                          }
                        },
                        child: const Text('Select Image'),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (edit) {
                                newStoreItem.name = nameController.text != ""
                                    ? nameController.text
                                    : item!.name;
                                newStoreItem.price = priceController.text != ""
                                    ? double.tryParse(priceController.text) ??
                                        item!.price
                                    : item!.price;
                                newStoreItem.discount =
                                    discountController.text != ""
                                        ? double.tryParse(
                                                discountController.text)! /
                                            100
                                        : item!.discount;
                                newStoreItem.imageData = base64Image;
                                newStoreItem.details =
                                    detailsController.text != ""
                                        ? detailsController.text
                                        : item!.details;
                                newStoreItem.storeItemCategoryId =
                                    newStoreItem.storeItemCategoryId ??
                                        item!.storeItemCategoryId;
                                newStoreItem.carModelIds = selectedCarModels
                                    .map((model) => model.id)
                                    .toList();
                                await Provider.of<StoreItemProvider>(context,
                                        listen: false)
                                    .updateStoreItem(item!.id, newStoreItem)
                                    .then((_) {
                                  _applyFilters();
                                });
                                Navigator.of(context).pop();
                              } else {
                                if (nameController.text == "" ||
                                    priceController.text == "") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Item name and price are required!'),
                                    ),
                                  );
                                } else {
                                  newStoreItem.name = nameController.text;
                                  newStoreItem.price =
                                      double.tryParse(priceController.text) ??
                                          0;
                                  newStoreItem.discount = discountController.text != ""
                                        ? double.tryParse(
                                                discountController.text)! /
                                            100
                                        : 0;
                                  newStoreItem.imageData = base64Image;
                                  newStoreItem.details = detailsController.text;
                                  newStoreItem.carModelIds = selectedCarModels
                                      .map((model) => model.id)
                                      .toList();
                                  await Provider.of<StoreItemProvider>(context,
                                          listen: false)
                                      .insertStoreItem(newStoreItem)
                                      .then((_) {
                                    Provider.of<StoreItemProvider>(context,
                                            listen: false)
                                        .getStoreItems();
                                  });
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _nameFilterController.dispose();
    super.dispose();
  }
}
