import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_parts_shop/src/models/store_item/store_item.dart';
import 'package:fixmycar_car_parts_shop/src/providers/store_item_provider.dart';
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
  TextEditingController _nameFilterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoreItemProvider>(context, listen: false).getStoreItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
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
                                  child: item.imageData != null
                                      ? Image.memory(
                                          base64Decode(item.imageData!),
                                          fit: BoxFit.contain,
                                          width: 200,
                                          height: 200,
                                        )
                                      : const SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: Placeholder(),
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
                                        text: '${item.price}KM ',
                                        style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.red,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ${item.discountedPrice}KM',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ] else ...[
                                      TextSpan(
                                        text: '${item.price}KM',
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
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Category: ${item.category ?? "Unknown"}',
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
    );
  }

  void _showFilterDialog(BuildContext context) {
    _nameFilterController.text = _filterName;

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
                      title: const Text('Draft'),
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

    if (_selectedStatusFilter != 'all') {
      stateFilter = _selectedStatusFilter;
    }

    if (_selectedDiscountFilter == 'discounted') {
      discountFilter = true;
    } else if (_selectedDiscountFilter == 'non-discounted') {
      discountFilter = false;
    }

    setState(() {
      _isFilterApplied = true;
    });

    provider.getStoreItems(
      nameFilter: _filterName.isNotEmpty ? _filterName : null,
      withDiscount: discountFilter,
      state: stateFilter,
    );
  }

  List<Widget> _buildActionButtons(StoreItem item) {
    if (item.state == 'draft') {
      return [
        ElevatedButton(
          onPressed: () {
            _showEditForm(context, item);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
          child: const Text('Edit'),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Logic for deleting the item
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
          child: const Text('Delete'),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Logic for activating the item
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
          child: const Text('Activate'),
        ),
      ];
    }
    return [];
  }

  void _showEditForm(BuildContext context, StoreItem item) {
    TextEditingController nameController =
        TextEditingController(text: item.name);
    TextEditingController discountController =
        TextEditingController(text: (item.discount * 100).toString());

    String? imagePath;
    String? base64Image = item.imageData;

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
                        controller: discountController,
                        decoration: const InputDecoration(
                          labelText: 'Discount (%)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      if (base64Image != null)
                        Image.memory(
                          base64Decode(base64Image!),
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                        )
                      else
                        const Placeholder(
                          fallbackHeight: 200,
                          fallbackWidth: 200,
                        ),
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
                            onPressed: () {
                              item.name = nameController.text;
                              item.discount =
                                  double.tryParse(discountController.text)! /
                                      100;
                              item.imageData = base64Image;
                              Provider.of<StoreItemProvider>(context,
                                      listen: false)
                                  .updateStoreItem(item.id, item)
                                  .then((_) {
                                Provider.of<StoreItemProvider>(context,
                                        listen: false)
                                    .getStoreItems();
                              });
                              Navigator.of(context).pop();
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
