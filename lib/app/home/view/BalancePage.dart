// my_balance_page.dart
// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
// Import your separate files:
import 'SummaryTabBalance.dart';
import 'PurshaseTabBalance.dart';
import 'PaymentsTabBalance.dart';

class MyBalancePage extends StatefulWidget {
  const MyBalancePage({Key? key}) : super(key: key);

  @override
  State<MyBalancePage> createState() => _MyBalancePageState();
}

class _MyBalancePageState extends State<MyBalancePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // We have three tabs: Summary, Purchase, Payments
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --------------------------------
  // BUILD
  // --------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // -- (1) Background + Custom AppBar
          Stack(
            children: [
              // Background image at the top
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRElHzS7DF6u04X-Y0OPLE2YkIIcaI6XjbB5K5atLN_ZCPg_Un9',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Custom AppBar on top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  backgroundColor: Colors.black.withOpacity(0.7),
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.orangeAccent),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: const Text(
                    "My Balance",
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
            ],
          ),

          // -- (2) Tab Bar (dark background)
          Container(
            color: const Color(0xFF000610), // A dark color for contrast
            child: TabBar(
              controller: _tabController,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.orangeAccent, width: 2),
              ),
              labelColor: Colors.orangeAccent,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              tabs: const [
                Tab(text: "Summary"),
                Tab(text: "Purchase"),
                Tab(text: "Payments"),
              ],
            ),
          ),

          // -- (3) TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Summary tab
                buildSummaryTab(),

                // Purchase tab
                buildPurchaseTab(),

                // Payments tab
                buildPaymentsTab(),
              ],
            ),
          ),

          // -- (4) Pay Button pinned at the bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Handle Pay Button logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pay button clicked!"),
                  ),
                );
              },
              child: const Text(
                "Pay",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
