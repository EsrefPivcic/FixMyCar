import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/product_provider.dart';
import 'master_screen.dart';
import 'dart:convert';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      child: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.products.isEmpty) {
            provider.getProducts();
            return const Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return SizedBox(
                  height: 200, // Adjust the height of each card
                  width: 200,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: product['imageData'] != null
                              ? Container(
                                  constraints: BoxConstraints(
                                    maxHeight: 120,
                                  ),
                                  child: Image.memory(
                                    base64Decode(product['imageData']),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Placeholder(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product['name'] ?? 'Unknown Product',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        if (product['discount'] != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Discount: ${(product['discount']['value'] * 100).toInt()}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
