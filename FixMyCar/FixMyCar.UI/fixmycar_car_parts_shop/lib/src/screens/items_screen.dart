import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/product_provider.dart';
import 'master_screen.dart';
import 'dart:convert';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({Key? key}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  String _selectedStatusFilter = 'all';
  String _selectedDiscountFilter = 'all';
  String _filterName = '';

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      child: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.products.isEmpty) {
            provider.getProducts();
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                // Filter button
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
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1, // Adjust ratio for card height
                    ),
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
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
                                  child: product['imageData'] != null
                                      ? Image.memory(
                                          base64Decode(product['imageData']),
                                          fit: BoxFit.contain,
                                          width: 200, // Limit image width
                                          height: 200, // Limit image height
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
                                product['name'] ?? 'Unknown Product',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (product['discount'] != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Discount: ${(product['discount']['value'] * 100).toInt()}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            // Buttons for each card based on state
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: _buildActionButtons(product['state']),
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
          }
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filters'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filter by Name'),
                TextField(
                  decoration: const InputDecoration(hintText: 'Enter name'),
                  onChanged: (value) {
                    setState(() {
                      _filterName = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text('Product Status'),
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
                // Logic to apply filters will be implemented here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildActionButtons(String state) {
    if (state == 'active') {
      return [
        ElevatedButton(
          onPressed: () {
            // Logic for deactivating the product
          },
          child: const Text('Deactivate'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
        ),
      ];
    } else if (state == 'draft') {
      return [
        ElevatedButton(
          onPressed: () {
            // Logic for editing the product
          },
          child: const Text('Edit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Logic for deleting the product
          },
          child: const Text('Delete'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Logic for activating the product
          },
          child: const Text('Activate'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
          ),
        ),
      ];
    }
    return [];
  }
}
