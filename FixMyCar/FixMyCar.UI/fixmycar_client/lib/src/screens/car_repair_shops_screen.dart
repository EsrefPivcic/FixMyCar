import 'package:fixmycar_client/src/models/user/user_search_object.dart';
import 'package:fixmycar_client/src/screens/car_repair_shop_services_screen.dart';
import 'package:fixmycar_client/src/screens/reservation_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'master_screen.dart';
import 'package:fixmycar_client/src/models/user/user.dart';
import 'package:fixmycar_client/src/providers/car_repair_shop_provider.dart';

class CarRepairShopsScreen extends StatefulWidget {
  const CarRepairShopsScreen({Key? key}) : super(key: key);

  @override
  _CarRepairShopsScreenState createState() => _CarRepairShopsScreenState();
}

class _CarRepairShopsScreenState extends State<CarRepairShopsScreen> {
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
      Provider.of<CarRepairShopProvider>(context, listen: false)
          .getRepairShops(pageNumber: _pageNumber, pageSize: _pageSize);
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
              title: const Text('Filter by name'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Apply'),
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
    final provider = Provider.of<CarRepairShopProvider>(context, listen: false);

    setState(() {
      _isFilterApplied = true;
    });

    provider.getRepairShops(
        search: UserSearchObject(
            _filterName.isNotEmpty ? _filterName : null, true, null),
        pageNumber: _pageNumber,
        pageSize: _pageSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MasterScreen(
        child: Consumer<CarRepairShopProvider>(
          builder: (context, provider, child) {
            if (!provider.isLoading) {
              _totalPages = (provider.countOfItems / _pageSize).ceil();
            }
            return Column(
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        label: const Text("Filter by name"),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.history),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(18, 255, 255, 255)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ReservationHistoryScreen(),
                            ),
                          );
                        },
                        label: const Text("Reservation History"),
                      ),
                    ],
                  ),
                ),
                if (provider.isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (provider.carRepairShops.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        _isFilterApplied
                            ? 'No results found for your search.'
                            : 'No services available.',
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(5.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: provider.carRepairShops.length,
                      itemBuilder: (context, index) {
                        final User carRepairShop =
                            provider.carRepairShops[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CarRepairShopServicesScreen(
                                        carRepairShop: carRepairShop),
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: carRepairShop.image != ""
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.memory(
                                                base64Decode(
                                                    carRepairShop.image!),
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                              ),
                                            )
                                          : Icon(Icons.image,
                                              size: 80,
                                              color: Colors.grey[400]),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    carRepairShop.username,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Owner: ${carRepairShop.name} ${carRepairShop.surname}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.location_city,
                                          size: 16,
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                      const SizedBox(width: 4),
                                      Text(carRepairShop.city,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone,
                                          size: 16,
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                      const SizedBox(width: 4),
                                      Text(carRepairShop.phone,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.access_time,
                                          size: 16,
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${parseTimeOfDay(carRepairShop.openingTime!).format(context)} - ${parseTimeOfDay(carRepairShop.closingTime!).format(context)}',
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
                        );
                      },
                    ),
                  ),
                if (provider.carRepairShops.isNotEmpty) ...[
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
    super.dispose();
  }
}
