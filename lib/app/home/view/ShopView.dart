// // products_page.dart
//
// import 'package:flutter/material.dart';
// import 'cart_service.dart';
// import 'cart_page.dart';
// import 'product_detail_page.dart';
//
// class ProductsPage extends StatefulWidget {
//   const ProductsPage({Key? key}) : super(key: key);
//
//   @override
//   State<ProductsPage> createState() => _ProductsPageState();
// }
//
// class _ProductsPageState extends State<ProductsPage> {
//   // Example products
//   final List<Map<String, dynamic>> allProducts = [
//     {
//       "id": 1,
//       "imageUrl": "https://via.placeholder.com/120x120.png?text=Product1",
//       "name": "Product 1",
//       "price": 100.0,
//       "oldPrice": 150.0,
//       "inStock": true,
//       "discountPercent": 33.3,
//       "isNew": true,
//     },
//     {
//       "id": 2,
//       "imageUrl": "https://via.placeholder.com/120x120.png?text=Product2",
//       "name": "Product 2",
//       "price": 80.0,
//       "oldPrice": 100.0,
//       "inStock": true,
//       "discountPercent": 20.0,
//       "isNew": false,
//     },
//     {
//       "id": 3,
//       "imageUrl": "https://via.placeholder.com/120x120.png?text=Product3",
//       "name": "Product 3",
//       "price": 150.0,
//       "oldPrice": null,
//       "inStock": false,
//       "discountPercent": 0.0,
//       "isNew": false,
//     },
//   ];
//
//   /// Refresh UI
//   void _refresh() => setState(() {});
//
//   /// Open cart page
//   void _goToCart() async {
//     print("Navigating to CartPage");
//     await Navigator.of(context).push(
//       MaterialPageRoute(builder: (_) => const CartPage()),
//     );
//     _refresh();
//   }
//
//   void _openProductDetail(Map<String, dynamic> product) async {
//     print("Navigating to ProductDetailPage for ${product["name"]}");
//     await Navigator.of(context).push(
//       MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
//     );
//     _refresh();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Simple appbar with cart icon
//       appBar: AppBar(
//         title: const Text("Products"),
//         backgroundColor: Colors.black,
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 onPressed: _goToCart,
//                 icon: const Icon(Icons.shopping_bag_outlined),
//               ),
//               if (CartService.getCartCount() > 0)
//                 Positioned(
//                   right: 6,
//                   top: 6,
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Text(
//                       "${CartService.getCartCount()}",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: allProducts.length,
//         itemBuilder: (ctx, i) {
//           final product = allProducts[i];
//           return _buildProductCard(product);
//         },
//       ),
//     );
//   }
//
//   Widget _buildProductCard(Map<String, dynamic> product) {
//     final name = product["name"] as String;
//     final price = product["price"] as double;
//     final oldPrice = product["oldPrice"] as double?;
//     final inStock = product["inStock"] as bool;
//     final discountPercent = product["discountPercent"] as double;
//     final isNew = product["isNew"] as bool;
//     final imageUrl = product["imageUrl"] as String;
//
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 2,
//       child: InkWell(
//         onTap: () => _openProductDetail(product),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               // Product image
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   imageUrl,
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(width: 12),
//
//               // Name + Price
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     // show old price if present
//                     if (oldPrice != null)
//                       Text(
//                         "EGP ${oldPrice.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                           decoration: TextDecoration.lineThrough,
//                           color: Colors.grey,
//                           fontSize: 12,
//                         ),
//                       ),
//                     Text(
//                       "EGP ${price.toStringAsFixed(2)}",
//                       style: const TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                     Text(
//                       inStock ? "In Stock" : "Out of Stock",
//                       style: TextStyle(
//                         color: inStock ? Colors.green : Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // discount/new
//               Column(
//                 children: [
//                   if (discountPercent > 0)
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.teal[100],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text("${discountPercent.toStringAsFixed(1)}%"),
//                     ),
//                   const SizedBox(height: 8),
//                   if (isNew)
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.orange,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Text(
//                         "NEW",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
