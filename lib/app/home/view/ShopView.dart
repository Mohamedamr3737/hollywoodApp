// products_page.dart
import 'dart:async'; // for Timer
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/shop_controller.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final shopController = Get.put(ShopController());

  // For local filter: "featured/hot/new" or "all"
  String localFilter = "all";

  // For search
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;

  // For categories
  int? selectedCategoryId; // if null => all categories

  @override
  void initState() {
    super.initState();
    // Fetch initial products page=1
    shopController.fetchProducts(page: 1);
    // Also fetch categories
    shopController.fetchCategories();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PRODUCTS"),
        centerTitle: true,
// products_page.dart (inside the AppBar actions)
        actions: [
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
      body: Column(
        children: [
          // (A) Search row (enhanced UI)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Search field with a container + decoration
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: _onSearchChanged, // Debounce logic
                      decoration: InputDecoration(
                        hintText: "Search product title...",
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Category dropdown
                Obx(() {
                  final cats = shopController.categories;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButton<int?>(
                      value: selectedCategoryId,
                      hint: const Text("All Cat", style: TextStyle(color: Colors.black)),
                      underline: const SizedBox(), // remove default underline
                      items: [
                        // "All categories" item
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text("All Categories"),
                        ),
                        // Then real categories
                        ...cats.map((c) {
                          final catId = c["id"] as int;
                          final catTitle = c["title"] as String;
                          return DropdownMenuItem<int?>(
                            value: catId,
                            child: Text(catTitle),
                          );
                        }).toList(),
                      ],
                      onChanged: (val) {
                        setState(() {
                          selectedCategoryId = val;
                        });
                        // Re-fetch from server with new category
                        _fetchFromServer(page: 1);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          // (B) Local filter row for "All/Featured/Hot/New"
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _buildLocalFilterButton("All", "all"),
                _buildLocalFilterButton("Featured", "featured"),
                _buildLocalFilterButton("Hot", "hot"),
                _buildLocalFilterButton("New", "new"),
                const Spacer(),
              ],
            ),
          ),

          // (C) Product list area
          Expanded(
            child: Obx(() {
              if (shopController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (shopController.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    shopController.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final products = shopController.products;
              if (products.isEmpty) {
                return const Center(child: Text("No products found."));
              }

              // Apply local filter for "featured/hot/new"
              final filtered = _applyLocalFilter(products);

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final product = filtered[index];
                  return _buildProductCard(product);
                },
              );
            }),
          ),

          // (D) Pagination row
          _buildPaginationRow(),
        ],
      ),
    );
  }

  // (1) Debounce search
  void _onSearchChanged(String val) {
    // Cancel previous timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // After 500ms of no typing, fetch from server
      _fetchFromServer(page: 1);
    });
  }

  // (2) Build local filter button
  Widget _buildLocalFilterButton(String label, String value) {
    final isSelected = (localFilter == value);
    return TextButton(
      onPressed: () {
        setState(() => localFilter = value);
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

  // (3) Apply local "featured/hot/new" filter
  List<Map<String, dynamic>> _applyLocalFilter(List<Map<String, dynamic>> items) {
    if (localFilter == "all") return items;

    return items.where((p) {
      if (localFilter == "featured") {
        return p["featured"] == true;
      } else if (localFilter == "hot") {
        return p["hot"] == true;
      } else if (localFilter == "new") {
        return p["new"] == true;
      }
      return true;
    }).toList();
  }

  // (4) Build a single product card
  Widget _buildProductCard(Map<String, dynamic> product) {
    final title = product["title"] as String;
    final imageUrl = product["image"] as String;
    final price = product["price"] as double;
    final oldPrice = product["oldPrice"] as double?;
    final canBuy = product["can_buy"] as bool;

    double discountPercentage = 0.0;
    if (oldPrice != null && oldPrice > price) {
      discountPercentage = 100.0 * (oldPrice - price) / oldPrice;
    }

    // Also check if "featured", "hot", or "new" is true => show a label
    final featured = product["featured"] == true;
    final hot = product["hot"] == true;
    final isNew = product["new"] == true;

    return Card(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          // Go to product detail
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _buildProductImage(imageUrl),
              const SizedBox(width: 8),
              // Title, price, discount, labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                    if (discountPercentage > 0)
                      Text(
                        "${discountPercentage.toStringAsFixed(1)}% discount",
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 12,
                        ),
                      ),
                    Row(
                      children: [
                        if (featured)
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "Featured",
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        if (hot)
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "Hot",
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        if (isNew)
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "New",
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    canBuy ? "In Stock" : "Out of Stock",
                    style: TextStyle(
                      color: canBuy ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canBuy ? Colors.black : Colors.grey,
                      side: canBuy
                          ? const BorderSide(color: Colors.orangeAccent)
                          : const BorderSide(color: Colors.grey),
                    ),
                    onPressed: canBuy
                        ? () {
                      // Add to cart
                      CartPage.addToCart(product, 1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$title added to cart")),
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

  // Helper to re-fetch from server with current page=1, plus search text, plus category
  void _fetchFromServer({int page = 1}) {
    final searchText = _searchCtrl.text.trim();
    shopController.fetchProducts(
      page: page,
      productTitle: searchText.isEmpty ? null : searchText,
      categoryId: selectedCategoryId,
    );
  }

  // Pagination row
  Widget _buildPaginationRow() {
    return Obx(() {
      final currentPage = shopController.currentPage.value;
      final totalPages = shopController.totalPages.value;
      return Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: currentPage > 1
                  ? () {
                _fetchFromServer(page: currentPage - 1);
              }
                  : null,
              child: const Text("Prev"),
            ),
            Text(
              "Page $currentPage / $totalPages",
              style: const TextStyle(color: Colors.white),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: currentPage < totalPages
                  ? () {
                _fetchFromServer(page: currentPage + 1);
              }
                  : null,
              child: const Text("Next"),
            ),
          ],
        ),
      );
    });
  }
}
