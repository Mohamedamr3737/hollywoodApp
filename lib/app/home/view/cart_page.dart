// cart_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_detail_page.dart';
import '../controller/shop_controller.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  static final List<Map<String, dynamic>> cartItems = [];

  static void addToCart(Map<String, dynamic> product, int quantity) {
    final index = cartItems.indexWhere((item) => item["product"]["id"] == product["id"]);
    if (index >= 0) {
      cartItems[index]["quantity"] += quantity;
    } else {
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
  bool _isSending = false;

  // Get the same ShopController instance
  final ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
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
    final finalTotal = subTotal;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Cart list
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
          // Summary
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: CartPage.cartItems.isEmpty || _isSending
                        ? null
                        : () {
                      _sendOrder();
                    },
                    child: _isSending
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Sending...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                        : const Text(
                      "Send to Order",
                      style: TextStyle(color: Colors.white),
                    ),
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

    final title = product["title"] as String;
    final price = product["price"] as double;
    final oldPrice = product["oldPrice"] as double?;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
        ).then((_) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.orange[500],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Title + price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.isEmpty ? "." : title,
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
            // Stepper
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
            // Remove
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
      ),
    );
  }

  /// Calls shopController.storeOrder(...) to send the cart items to the server
  Future<void> _sendOrder() async {
    setState(() => _isSending = true);

    final msg = await shopController.storeOrder(CartPage.cartItems);
    // If msg starts with "Error:" or "Exception:", it's an error
    if (msg.toLowerCase().contains("error") || msg.toLowerCase().contains("exception")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } else {
      // success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
      // Optionally clear cart
      setState(() {
        CartPage.cartItems.clear();
      });
    }

    setState(() => _isSending = false);
  }
}
