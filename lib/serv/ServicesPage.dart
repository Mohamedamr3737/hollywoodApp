// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_medi/serv/ServiceDetailPage.dart';

class ServicesPage extends StatelessWidget {
  final List<Service> services = [
    Service(
      title: 'Morpheus 8',
      description:
          'The deeper and most powerful face and body tightening technology...',
      imagePath:
          'https://media.istockphoto.com/id/1321856038/photo/portrait-beautiful-young-woman-with-clean-fresh-skin.jpg?s=612x612&w=0&k=20&c=jP4pZTdV_7hHPMhFUaFNZSAbIDQAOUEcrMPMwSKFLqk=',
      details:
          'The deeper and most powerfull face and body tightening technology The Morpheus8 is a new subdermal adipose remodeling device (SARD) that fractionally remodels ,contours and  tight  the face and body . Penetrating deep into the skin and fat, this morphs the aging face or body into a more desired smooth and sleek appearance, for all skin tones.',
      detailImages: [
        'https://comitemdskin.com/wp-content/uploads/2022/08/Morpheus_banner_v2.jpg',
      ],
      text: null,
    ),

    Service(
      title: 'Morpheus 8',
      description:
          'The deeper and most powerful face and body tightening technology...',
      imagePath:
          'https://media.istockphoto.com/id/1321856038/photo/portrait-beautiful-young-woman-with-clean-fresh-skin.jpg?s=612x612&w=0&k=20&c=jP4pZTdV_7hHPMhFUaFNZSAbIDQAOUEcrMPMwSKFLqk=',
      details:
          'The deeper and most powerful face and body tightening technology...',
      detailImages: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmha5aZ45AUQyyheaRCnWnpmnoODetun4icLO0WGGGtHVaLmgTmPMmtY6CaWha9egCeOA&usqp=CAU',
        'https://comitemdskin.com/wp-content/uploads/2022/08/Morpheus_banner_v2.jpg',
      ],
      text: null,
    ),
    Service(
      title: 'Morpheus 8',
      description:
          'The deeper and most powerful face and body tightening technology...',
      imagePath:
          'https://media.istockphoto.com/id/1321856038/photo/portrait-beautiful-young-woman-with-clean-fresh-skin.jpg?s=612x612&w=0&k=20&c=jP4pZTdV_7hHPMhFUaFNZSAbIDQAOUEcrMPMwSKFLqk=',
      details:
          'The deeper and most powerful face and body tightening technology...',
      detailImages: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmha5aZ45AUQyyheaRCnWnpmnoODetun4icLO0WGGGtHVaLmgTmPMmtY6CaWha9egCeOA&usqp=CAU',
        'https://comitemdskin.com/wp-content/uploads/2022/08/Morpheus_banner_v2.jpg',
      ],
      text: null,
    ),
    Service(
      title: 'Morpheus 8',
      description:
          'The deeper and most powerful face and body tightening technology...',
      imagePath:
          'https://media.istockphoto.com/id/1321856038/photo/portrait-beautiful-young-woman-with-clean-fresh-skin.jpg?s=612x612&w=0&k=20&c=jP4pZTdV_7hHPMhFUaFNZSAbIDQAOUEcrMPMwSKFLqk=',
      details:
          'The deeper and most powerful face and body tightening technology...',
      detailImages: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmha5aZ45AUQyyheaRCnWnpmnoODetun4icLO0WGGGtHVaLmgTmPMmtY6CaWha9egCeOA&usqp=CAU',
        'https://comitemdskin.com/wp-content/uploads/2022/08/Morpheus_banner_v2.jpg',
      ],
      text: null,
    ),

    // Additional services...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Services", style: TextStyle(color: Colors.black)),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
          ),
          SizedBox(height: 16),
          Text(
            "Our Features & Services",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          // List of ServiceCards in a vertical scroll direction
          ...services.map((service) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ServiceCard(service: service),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class Service {
  final String title;
  final String description;
  final String imagePath;
  final String details;
  final List<String> detailImages;
  final String? text;

  Service({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.details,
    required this.detailImages,
    this.text,
  });
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
            ClipOval(
              child: Image.network(
                service.imagePath,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: Colors.red, size: 100);
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              service.title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              service.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: StadiumBorder(),
              ),
              onPressed: () {
                Get.to(() => ServiceDetailPage(service: service));
              },
              child: Text('Read More', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
