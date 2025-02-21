// cart_page.dart
import 'package:flutter/material.dart';

/// A global static cart (list of Maps). Each item is:
///   { "product": <productMap>, "quantity": <int> }
class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  // The global cart list
  static final List<Map<String, dynamic>> cartItems = [];

  /// Add an item to the cart. If the product already exists, increment quantity.
  static void addToCart(Map<String, dynamic> product, int quantity) {
    // Check if product is already in the cart
    final index = cartItems.indexWhere((item) => item["product"] == product);
    if (index >= 0) {
      // Already in cart, just increment
      cartItems[index]["quantity"] += quantity;
    } else {
      // Insert new item
      cartItems.add({
        "product": product,
        "quantity": quantity,
      });
    }
  }

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    // Calculate totals
    double subTotal = 0.0;
    double discountTotal = 0.0;
    int totalQuantity = 0;

    for (var item in CartPage.cartItems) {
      final product = item["product"] as Map<String, dynamic>;
      final quantity = item["quantity"] as int;
      final price = product["price"] as double;
      final oldPrice = product["oldPrice"] as double?;

      subTotal += price * quantity;
      if (oldPrice != null && oldPrice > price) {
        discountTotal += (oldPrice - price) * quantity;
      }
      totalQuantity += quantity;
    }

    double finalTotal = subTotal; // If there's more discount logic, apply it

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // (A) Cart list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: CartPage.cartItems.length,
              itemBuilder: (context, index) {
                final item = CartPage.cartItems[index];
                return _buildCartItem(item);
              },
            ),
          ),

          // (B) Summary at bottom
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text("$totalQuantity"),
                  ],
                ),
                Row(
                  children: [
                    const Text("SubTotal", style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text("${subTotal.toStringAsFixed(1)} EGP"),
                  ],
                ),
                Row(
                  children: [
                    const Text("Discount", style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text("${discountTotal.toStringAsFixed(1)} EGP"),
                  ],
                ),
                Row(
                  children: [
                    const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text("${finalTotal.toStringAsFixed(1)} EGP"),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Send to Order!")),
                    );
                  },
                  child: const Text(
                    "Send to Order",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final product = item["product"] as Map<String, dynamic>;
    final quantity = item["quantity"] as int;

    final name = product["name"] as String;
    final price = product["price"] as double;
    final oldPrice = product["oldPrice"] as double?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.orange[500],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // A) Name + oldPrice + newPrice
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? "." : name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      "${price.toStringAsFixed(2)} EGP",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (oldPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        "${oldPrice.toStringAsFixed(2)} EGP",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // B) Quantity stepper
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (quantity > 1) {
                      item["quantity"] = quantity - 1;
                    }
                  });
                },
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text("$quantity"),
              IconButton(
                onPressed: () {
                  setState(() {
                    item["quantity"] = quantity + 1;
                  });
                },
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // C) Remove button
          IconButton(
            onPressed: () {
              setState(() {
                CartPage.cartItems.remove(item);
              });
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
