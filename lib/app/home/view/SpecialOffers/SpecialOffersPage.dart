// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../controller/SpecialOffersController.dart';

class SpecialOffersPage extends StatefulWidget {
  const SpecialOffersPage({super.key});

  @override
  State<SpecialOffersPage> createState() => _SpecialOffersPageState();
}

class _SpecialOffersPageState extends State<SpecialOffersPage> {
  late Future<String> _futureHtmlContent;
  final SpecialOffersController _controller = SpecialOffersController();

  @override
  void initState() {
    super.initState();
    _futureHtmlContent = _controller.fetchOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _futureHtmlContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Full-page loading indicator while waiting for the API call.
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final htmlContent = snapshot.data!;
            return Stack(
              children: [
                // Background image with AppBar overlay
                Column(
                  children: [
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
                    const SizedBox(height: 60), // Space for the circular logo
                  ],
                ),
                // Positioned Circular Logo
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
                          'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSEa7ew_3UY_z3gT_InqdQmimzJ6jC3n2WgRpMUN9yekVsUxGIg',
                        ),
                        fit: BoxFit.contain,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                // Custom AppBar
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
                      "Special Offers",
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                  ),
                ),
                // Content: display the parsed HTML content.
                Positioned.fill(
                  top: 200, // Below the background image and logo
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Html(
                      data: htmlContent,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
