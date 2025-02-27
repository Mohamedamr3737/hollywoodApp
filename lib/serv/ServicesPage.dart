import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';

// If you want to parse HTML in ServiceDetailPage, import flutter_html there.

// Example detail page that can parse HTML in the 'body' field.
class ServiceDetailPage extends StatelessWidget {
  final Service service;

  const ServiceDetailPage({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.title),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Image
            Image.network(
              service.imagePath,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              service.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Short description or details
            Text(
              service.details,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Parse the HTML body using flutter_html
            Html(
              data: service.body ?? "",
              // Optionally customize styling or behavior
              style: {
                "body": Style(
                  fontSize: FontSize(5),
                  color: Colors.black87,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
/// Model class for each service item.
class Service {
  final String title;
  final String description;
  final String imagePath;
  final String details;
  final List<String>? detailImages;
  final String? body; // Add 'body' field to hold HTML or detailed text.

  Service({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.details,
    this.detailImages,
    this.body,
  });

  /// Factory constructor to parse JSON from the API.
  factory Service.fromJson(Map<String, dynamic> json) {
    // Adjust keys to match your API fields.
    // e.g., "title", "short_description", "image", "body"
    return Service(
      title: json["title"] ?? "",
      description: json["short_description"] ?? "",
      imagePath: json["image"] ?? "",
      details: "", // We'll fill this with short_description or body if needed
      detailImages: [],
      body: json["body"] ?? "",
    );
  }
}

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  bool isLoading = false;
  String errorMessage = "";
  List<Service> services = [];

  /// Fetch services from the API.
  Future<void> fetchServices() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse("https://portal.ahmed-hussain.com/api/patient/pages/Service");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == true) {
          // data["data"] should be a list of service items
          final List<dynamic> rawServices = data["data"];
          services = rawServices.map((jsonItem) => Service.fromJson(jsonItem)).toList();
          errorMessage = '';
        } else {
          errorMessage = data["message"] ?? "Failed to fetch services.";
        }
      } else {
        errorMessage = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "An error occurred: $e";
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
          ),
          const SizedBox(height: 16),
          const Text(
            "Our Features & Services",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Build a list of ServiceCards from the fetched data
          for (var service in services)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ServiceCard(service: service),
            ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Service service;
  const ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circle image
            ClipOval(
              child: Image.network(
                service.imagePath,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red, size: 100);
                },
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              service.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Short description
            Text(
              service.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // "Read More" button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                // Pass the entire service object to detail page
                Get.to(() => ServiceDetailPage(service: service));
              },
              child: const Text('Read More', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: const ServicesPage(),
  ));
}
