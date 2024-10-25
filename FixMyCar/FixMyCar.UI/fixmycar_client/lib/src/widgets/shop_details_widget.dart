import 'package:fixmycar_client/src/models/car_parts_shop_discount/car_parts_shop_discount.dart';
import 'package:fixmycar_client/src/models/car_repair_shop_discount/car_repair_shop_discount.dart';
import 'package:fixmycar_client/src/models/personal_discount/personal_discount.dart';
import 'package:fixmycar_client/src/models/user/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

void showShopDetailsDialog(
    BuildContext context,
    User shopDetails,
    List<CarRepairShopDiscount>? carRepairShopdiscounts,
    List<CarPartsShopDiscount>? carPartsShopDiscounts) {
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
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  shopDetails.username,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (shopDetails.image != null)
                  Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    height: 150,
                    child: shopDetails.image != ""
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              base64Decode(shopDetails.image!),
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                          )
                        : Icon(Icons.image, size: 80, color: Colors.grey[400]),
                  ),
                _buildDetailRow('Owner',
                    "${shopDetails.name} ${shopDetails.surname}", context),
                _buildDetailRow('City', shopDetails.city, context),
                _buildDetailRow(
                  'Address',
                  shopDetails.address,
                  context,
                ),
                _buildDetailRow('Phone', shopDetails.phone, context),
                _buildDetailRow('Email', shopDetails.email, context),
                _buildDetailRow(
                  'Work Time',
                  '${_parseTimeOfDay(shopDetails.openingTime!).format(context)} - ${_parseTimeOfDay(shopDetails.closingTime!).format(context)}',
                  context,
                ),
                _buildDetailRow(
                  'Work Days',
                  shopDetails.workDays!
                      .map((day) => day.substring(0, 3))
                      .join(', '),
                  context,
                ),
                if (shopDetails.employees != null) ...[
                  _buildDetailRow('Number of Employees',
                      shopDetails.employees.toString(), context),
                ],
                if (carRepairShopdiscounts != null &&
                    carRepairShopdiscounts.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Personal Discounts',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  for (var discount in carRepairShopdiscounts)
                    _buildDiscountRow(discount, null, context),
                ],
                if (carPartsShopDiscounts != null &&
                    carPartsShopDiscounts.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Personal Discounts',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  for (var discount in carPartsShopDiscounts)
                    _buildDiscountRow(null, discount, context),
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

Widget _buildDiscountRow(CarRepairShopDiscount? carRepairShopDiscount,
    CarPartsShopDiscount? carPartsShopDiscount, BuildContext context) {
  PersonalDiscount discount;
  if (carRepairShopDiscount != null) {
    discount = PersonalDiscount(carRepairShopDiscount.value,
        carRepairShopDiscount.created, carRepairShopDiscount.revoked);
  } else {
    discount = PersonalDiscount(carPartsShopDiscount!.value,
        carPartsShopDiscount.created, carPartsShopDiscount.revoked);
  }
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
