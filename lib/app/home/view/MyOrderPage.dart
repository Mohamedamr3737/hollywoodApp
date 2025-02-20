import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// The root widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Orders Demo',
      debugShowCheckedModeBanner: false,
      home: const MyOrdersPage(),
    );
  }
}

// -----------------------------------------
// MyOrdersPage
// -----------------------------------------
class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  // Example list of orders. Each is a Map with:
  // {
  //   'orderNum': '#1213',
  //   'status': 'Completed',
  //   'total': 0.00,
  //   'date': '2025-02-19'
  // }
  // If you want to test the “No Orders” UI, set this to an empty list: []
  final List<Map<String, dynamic>> _orders = [
    {
      'orderNum': '#1213',
      'status': 'Completed',
      'total': 0.00,
      'date': '2025-02-19',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // (1) Background image & space for top
          Column(
            children: [
              // Header image
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
              // Extra space for the circular logo
              const SizedBox(height: 60),
            ],
          ),
          // (2) Positioned Circular Logo
          Positioned(
            top: 100, // Adjust as needed
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                // Replace this with your own logo if desired:
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://cdn3.iconfinder.com/data/icons/zen-2/100/Lotus_5-512.png',
                  ),
                  fit: BoxFit.contain,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          // (3) Custom AppBar on top
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
                "My Orders",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          // (4) Content below the circle
          Positioned.fill(
            top: 200, // so it appears below the circle
            child: _orders.isEmpty
                ? _buildNoOrdersUI()
                : _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------
  // If there are no orders, show "No Orders"
  // -----------------------------------------
  Widget _buildNoOrdersUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            "No Orders",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "You have no orders yet.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------
  // If there are orders, show them in a list
  // -----------------------------------------
  Widget _buildOrdersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        final orderNum = order['orderNum'] as String;
        final status = order['status'] as String;
        final total = order['total'] as double;
        final date = order['date'] as String;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.orange[300], // or Colors.orangeAccent
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: "Order Num #..." and "Completed"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Num $orderNum",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ).withBackground(color: Colors.green),
                ],
              ),
              const SizedBox(height: 8),

              // Row: "Total" on left and "EGP ..." on right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Text(
                    "EGP ${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Date and "VIEW" button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to Order Details page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OrderDetailsPage(order: order),
                        ),
                      );
                    },
                    child: const Text(
                      "VIEW",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Simple extension to wrap a widget in a colored container
// for the “Completed” label background effect.
extension WidgetBackground on Widget {
  Widget withBackground({Color color = Colors.green}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: this,
    );
  }
}

// -----------------------------------------
// OrderDetailsPage
// -----------------------------------------
class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderNum = order['orderNum'] ?? '';
    final status = order['status'] ?? '';
    final total = order['total'] ?? 0.0;
    final date = order['date'] ?? '';

    return Scaffold(
      body: Stack(
        children: [
          // Top background image
          Column(
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Image.network(
                  'https://images.unsplash.com/photo-1601984845798-44b10f90c361?ixlib=rb-4.0.3&q=80&w=1400',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
          // Circle logo (or lotus)
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://cdn3.iconfinder.com/data/icons/zen-2/100/Lotus_5-512.png',
                  ),
                  fit: BoxFit.contain,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          // Custom app bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.7),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.orangeAccent),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                "Order Details $orderNum",
                style: const TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          // Content
          Positioned.fill(
            top: 200,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Status and date in a row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          status,
                          style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          date.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // "Items" label
                    Row(
                      children: const [
                        Text(
                          "Items",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Example item card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                // Example image of a product:
                                'https://via.placeholder.com/100',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: const Text(".", // example product name
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text("1 x EGP 0.00"),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Some summary details
                    _buildLabelValueRow("Quantity", "1"),
                    const Divider(),
                    _buildLabelValueRow("SubTotal", "EGP 1500.00"),
                    const Divider(),
                    _buildLabelValueRow("Discount", "EGP 1500.00"),
                    const Divider(),
                    _buildLabelValueRow(
                      "Total",
                      "EGP ${total.toStringAsFixed(2)}",
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValueRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                color: isHighlight ? Colors.teal : Colors.grey[800],
              )),
          Text(value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                color: isHighlight ? Colors.teal : Colors.black,
              )),
        ],
      ),
    );
  }
}
