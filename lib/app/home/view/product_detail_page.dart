// product_detail_page.dart
import 'package:flutter/material.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product; // Each product is a Map
  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final name = product["name"] as String;
    final imageUrl = product["imageUrl"] as String;
    final price = product["price"] as double;
    final oldPrice = product["oldPrice"] as double?;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
              setState(() {}); // refresh after returning
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // (A) Product image (with placeholder if needed)
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

            // (B) Name
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // (C) Price row
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

            // (D) "Product Details" label
            const Text(
              "Product Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Some dummy text (just using the product name)
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),

            // (E) Quantity row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _quantity > 1
                      ? () {
                    setState(() {
                      _quantity--;
                    });
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
                    setState(() {
                      _quantity++;
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // (F) Add to cart button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                // Add to cart with chosen quantity
                CartPage.addToCart(product, _quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$name added to cart (x$_quantity)"),
                  ),
                );
              },
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
