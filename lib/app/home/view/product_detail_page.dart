import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final String title = product["title"] as String;
    final String imageUrl = product["image"] as String;
    final double price = product["price"] as double;
    final double? oldPrice = product["oldPrice"] as double?;
    final bool canBuy = product["can_buy"] as bool;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        centerTitle: true,
        actions: [
          // Reactive cart icon with badge
          Obx(() {
            int itemCount = CartPage.cartItems.length;
            return Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    );
                    setState(() {}); // Refresh state if needed on return
                  },
                ),
                if (itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$itemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Product image
            if (imageUrl.isEmpty)
              const SizedBox(
                width: 200,
                height: 200,
                child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
              )
            else
              Image.network(
                imageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    width: 200,
                    height: 200,
                    child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                  );
                },
              ),
            const SizedBox(height: 16),
            // Product title
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Price row with old price (if any)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "EGP ${price.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (oldPrice != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    "EGP ${oldPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            // "Product Details" label and dummy details text
            const Text(
              "Product Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            // Quantity selector row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _quantity > 1
                      ? () {
                    setState(() => _quantity--);
                  }
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  "$_quantity",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => _quantity++);
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Add to Cart button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: canBuy ? Colors.black : Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: canBuy
                  ? () {
                // Add item to cart with the chosen quantity
                CartPage.addToCart(product, _quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$title added to cart (x$_quantity)")),
                );
              }
                  : null,
              child: const Text(
                "Add to cart",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
