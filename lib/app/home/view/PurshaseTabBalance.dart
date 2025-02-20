// purchase_tab_balance.dart
import 'package:flutter/material.dart';

// Example data for the Purchase tab
final List<Map<String, dynamic>> purchaseItems = [
  {
    "type": "Appointment",
    "name": "Skin Care",
    "cost": 500.0,
    "discount": null, // no discount
    "dateTime": "2025-02-19 13:44 PM",
  },
  {
    "type": "Session",
    "name": "Forma",
    "cost": 0.0,
    "discount": 2500.0, // show strikethrough
    "dateTime": "2025-01-29 20:28 PM",
  },
  {
    "type": "Session",
    "name": "i face",
    "cost": 1250.0,
    "discount": 4500.0,
    "dateTime": "2025-01-29 18:50 PM",
  },
  {
    "type": "Session",
    "name": "laser full body plus",
    "cost": 1500.0,
    "discount": 6000.0,
    "dateTime": "2025-01-27 13:34 PM",
  },
  {
    "type": "Session",
    "name": "full arms",
    "cost": 1250.0,
    "discount": 2500.0,
    "dateTime": "2025-01-23 09:52 AM",
  },
];

Widget buildPurchaseTab() {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: purchaseItems.length,
    itemBuilder: (context, index) {
      final item = purchaseItems[index];
      final itemType = item["type"] as String;
      final itemName = item["name"] as String;
      final cost = item["cost"] as double;
      final discount = item["discount"] as double?;
      final dateTime = item["dateTime"] as String;

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
            // Appointment / Session
            Text(
              itemType,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Name + cost + optional discount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  itemName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${cost.toStringAsFixed(2)} EGP",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (discount != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        "${discount.toStringAsFixed(2)} EGP",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),
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
