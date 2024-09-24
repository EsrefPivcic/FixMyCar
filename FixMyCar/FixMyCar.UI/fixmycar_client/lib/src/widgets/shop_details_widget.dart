import 'package:fixmycar_client/src/models/user/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

void showShopDetailsDialog(BuildContext context, User shopDetails) {
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
                          : Icon(Icons.image,
                              size: 80, color: Colors.grey[400]),
                    ),
                  _buildDetailRow(
                      'Owner',
                      "${shopDetails.name} ${shopDetails.surname}",
                      context),
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