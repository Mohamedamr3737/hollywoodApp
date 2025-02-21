// products_page.dart
import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

// Dummy data for products. Each is a Map with keys:
//   "name", "imageUrl", "price", "oldPrice", "inStock"
final List<Map<String, dynamic>> dummyProducts = [
  {
    "name": "Post peel",
    "imageUrl": "", // intentionally blank to show placeholder
    "price": 0.0,
    "oldPrice": 1000.0,
    "inStock": true,
  },
  {
    "name": "laroche posay laboratoire dermatologique serum",
    "imageUrl": "https://via.placeholder.com/100x100.png?text=Serum",
    "price": 1150.0,
    "oldPrice": null,
    "inStock": true,
  },
];

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // Track which tab is selected: 0 = All, 1 = New Arrivals
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top AppBar with "PRODUCTS" + Filter + Cart icons
      appBar: AppBar(
        title: const Text("PRODUCTS"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Filter clicked!")),
              );
            },
          ),
          // Cart icon
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () async {
              // Navigate to cart page
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
              // After returning, refresh to show updated cart if needed
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // (A) Row with "All", "New Arrivals"
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _buildTabButton("All", 0),
                _buildTabButton("New Arrivals", 1),
                const Spacer(),
              ],
            ),
          ),
          // (B) Expanded list of products
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: dummyProducts.length,
              itemBuilder: (context, index) {
                final product = dummyProducts[index];
                return _buildProductCard(context, product);
              },
            ),
          ),
        ],
      ),
    );
  }

  // A tab button for "All" or "New Arrivals"
  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTab == index;
    return TextButton(
      onPressed: () {
        setState(() => _selectedTab = index);
      },
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.orangeAccent : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // A single product card, matching your black background + discount style
  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final name = product["name"] as String;
    final imageUrl = product["imageUrl"] as String;
    final price = product["price"] as double;
    final oldPrice = product["oldPrice"] as double?;
    final inStock = product["inStock"] as bool;

    // Calculate discount % if oldPrice != null
    double discountPercentage = 0.0;
    if (oldPrice != null && oldPrice > price) {
      discountPercentage = 100.0 * (oldPrice - price) / oldPrice;
    }

    return Card(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          // Navigate to product detail page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(product: product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // (1) Product image (with placeholder if empty)
              _buildProductImage(imageUrl),
              const SizedBox(width: 8),
              // (2) Name + Price + discount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price row
                    Row(
                      children: [
                        Text(
                          "EGP ${price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (oldPrice != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            "EGP ${oldPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    // (Optional) discount label
                    if (discountPercentage > 0)
                      Text(
                        "${discountPercentage.toStringAsFixed(1)}% new",
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // (3) Stock label + "Add to cart"
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Stock label
                  Text(
                    inStock ? "In Stock" : "Out of Stock",
                    style: TextStyle(
                      color: inStock ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // "Add to cart" button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Colors.orangeAccent),
                    ),
                    onPressed: inStock
                        ? () {
                      // Add to cart with quantity=1
                      CartPage.addToCart(product, 1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$name added to cart"),
                        ),
                      );
                    }
                        : null,
                    child: const Text(
                      "Add to cart",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // If imageUrl is empty or fails to load, show a placeholder icon
  Widget _buildProductImage(String url) {
    if (url.isEmpty) {
      return const SizedBox(
        width: 70,
        height: 70,
        child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
      );
    } else {
      return Image.network(
        url,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            width: 70,
            height: 70,
            child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
          );
        },
      );
    }
  }
}
