// payments_tab_balance.dart
import 'package:flutter/material.dart';

// Example data for the Payments tab
final List<Map<String, dynamic>> paymentItems = [
  {
    "type": "credit",
    "cost": 2500.0,
    "branch": "Heliopolis",
    "dateTime": "2025-01-29 18:52 PM",
  },
  {
    "type": "credit",
    "cost": 1500.0,
    "branch": "Heliopolis",
    "dateTime": "2025-01-27 12:05 PM",
  },
];

Widget buildPaymentsTab() {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: paymentItems.length,
    itemBuilder: (context, index) {
      final payItem = paymentItems[index];
      final type = payItem["type"] as String; // "credit"
      final cost = payItem["cost"] as double;
      final branch = payItem["branch"] as String;
      final dateTime = payItem["dateTime"] as String;

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.orange[500],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // e.g. "credit"
            Text(
              type,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // cost + branch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${cost.toStringAsFixed(1)} EGP",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  branch,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Date/time
            Text(
              dateTime,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      );
    },
  );
}
