// summary_tab_balance.dart
import 'package:flutter/material.dart';

// Make these public by removing the underscore from the name
Widget buildSummaryTab() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        // Current Balance Container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Current Balance",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "0.0 EGP",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // GridView with summary items
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
            children: [
              buildSummaryCard("Total Cost", "0.0 EGP"),
              buildSummaryCard("Total Discount", "0.0 EGP"),
              buildSummaryCard("After Discount", "0.0 EGP"),
              buildSummaryCard("Total Paid", "0.0 EGP"),
              buildSummaryCard("Total UnPaid", "0.0 EGP"),
              buildSummaryCard("Total Use", "0.0 EGP"),
              buildSummaryCard("Total UnUsed", "0.0 EGP"),
              buildSummaryCard("Refund", "0.0 EGP"),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildSummaryCard(String title, String value) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
