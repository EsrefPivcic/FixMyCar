import 'package:fixmycar_car_repair_shop/src/models/user/user_search_object.dart';
import 'package:fixmycar_car_repair_shop/src/screens/order_history_screen.dart';
import 'package:fixmycar_car_repair_shop/src/screens/store_items_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'master_screen.dart';
import 'package:fixmycar_car_repair_shop/src/models/user/user.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_parts_shop_provider.dart';

class CarPartsShopsScreen extends StatefulWidget {
  const CarPartsShopsScreen({Key? key}) : super(key: key);

  @override
  _CarPartsShopsScreenState createState() => _CarPartsShopsScreenState();
}

class _CarPartsShopsScreenState extends State<CarPartsShopsScreen> {
  String _filterName = '';
  TextEditingController _nameFilterController = TextEditingController();
  bool _isFilterApplied = false;
  int _pageNumber = 1;
  final int _pageSize = 10;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<CarPartsShopProvider>(context, listen: false)
          .getPartsShops(pageNumber: _pageNumber, pageSize: _pageSize);
    });
  }

  TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
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
    final provider = Provider.of<CarPartsShopProvider>(context, listen: false);

    setState(() {
      _isFilterApplied = true;
    });

    provider.getPartsShops(
        search: UserSearchObject(_filterName.isNotEmpty ? _filterName : null),
        pageNumber: _pageNumber,
        pageSize: _pageSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MasterScreen(
        showBackButton: false,
        child: Consumer<CarPartsShopProvider>(
          builder: (context, provider, child) {
            if (!provider.isLoading) {
              _totalPages = (provider.countOfItems / _pageSize).ceil();
            }
            return Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.filter_list,
                            color: Theme.of(context).primaryColorLight),
                        onPressed: () => _showFilterDialog(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.history),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(18, 255, 255, 255)),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderHistoryScreen(),
                          ),
                        ),
                        label: const Text("Order History"),
                      ),
                    ),
                  ],
                ),
                if (provider.isLoading)
                  const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                else if (provider.carPartsShops.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        _isFilterApplied
                            ? 'No results found for your search.'
                            : 'No shops available.',
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: provider.carPartsShops.length,
                      itemBuilder: (context, index) {
                        final User carPartsShop = provider.carPartsShops[index];

                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoreItemsScreen(
                                      carPartsShop: carPartsShop),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: carPartsShop.image != ""
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.memory(
                                                  base64Decode(
                                                      carPartsShop.image!),
                                                  fit: BoxFit.contain,
                                                  width: 200,
                                                  height: 200,
                                                ),
                                              )
                                            : Icon(Icons.image,
                                                size: 100,
                                                color: Colors.grey[400]),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      carPartsShop.username,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Owner: ${carPartsShop.name} ${carPartsShop.surname}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.grey[600]),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.location_city,
                                            size: 16,
                                            color: Theme.of(context)
                                                .primaryColorLight),
                                        const SizedBox(width: 4),
                                        Text(
                                          carPartsShop.city,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.phone,
                                            size: 16,
                                            color: Theme.of(context)
                                                .primaryColorLight),
                                        const SizedBox(width: 4),
                                        Text(
                                          carPartsShop.phone,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 16,
                                            color: Theme.of(context)
                                                .primaryColorLight),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${parseTimeOfDay(carPartsShop.openingTime).format(context)} - ${parseTimeOfDay(carPartsShop.closingTime).format(context)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 4,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                            const SizedBox(width: 4),
                                          ],
                                        ),
                                        Text(
                                          carPartsShop.workDays
                                              .map((day) => day.substring(0, 3))
                                              .join(', '),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (provider.carPartsShops.isNotEmpty) ...[
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
    );
  }

  @override
  void dispose() {
    _nameFilterController.dispose();
    _pageNumber = 1;
    super.dispose();
  }
}
