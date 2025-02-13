// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_medi/app/auth/view/MyServicesPage.dart';
import 'package:s_medi/app/home/view/AppointmentsPage.dart';
import 'package:s_medi/app/home/view/BalancePage.dart';
import 'package:s_medi/app/home/view/MyOrderPage.dart';
import 'package:s_medi/app/home/view/PrescriptionPage.dart';
import 'package:s_medi/app/home/view/ProfilePage.dart';
import 'package:s_medi/app/home/view/SpecialOffersPage.dart';

// Define your HomePage with the same UI structure
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Upper background image
              Image.network(
                'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRElHzS7DF6u04X-Y0OPLE2YkIIcaI6XjbB5K5atLN_ZCPg_Un9',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              // Circle profile icon
              Positioned(
                bottom: -50,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: const DecorationImage(
                      image: NetworkImage(
                          'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSEa7ew_3UY_z3gT_InqdQmimzJ6jC3n2WgRpMUN9yekVsUxGIg'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          // Grid of clickable options
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildOption(
                  context,
                  "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTrKVYM6Ttou8JcXZUDH5MJfUpVg4up-jZUUxeHiu-QQpcRtsd7",
                  "My Profile",
                  const ProfilePage(),
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSQyZNKxW9s5lEyrUlJKYIsVKzT4dbuLWHyNIhrO00viFluxBwZ",
                  "My Sessions",
                  const MySessionsPage(),
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJvshuC7e14u93nb1z_g4S1kvAIm86R0gQF-Zq4Iwq6-fZL4eY",
                  "Appointments",
                  const AppointmentsPage(),
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcT5-LAPHBq67t8jlkeQ3IkUcNbPVuvQvt8R7dQUxqG1eTbKiRJa",
                  "My Balance",
                  const MyBalancePage(),
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTE99tUgRwxcKQAWpnqMpWk69e2CvXj0NMIF6Img4DiU3pPsi0X",
                  "Special Offers",
                  const SpecialOffersPage(),
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRXi5xyC8STTuAtazhR44tMHwxldphRmj9zzNRtK9X23n-_p93k",
                  "My Order",
                  const MyOrderPage(),
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTusZ1LSpUqvBE3uLFQ3Y9oxEGt8nck4oJRRE3hm5xJEfs9F-An",
                  "Prescription",
                  const PrescriptionPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build each icon option
  Widget _buildOption(
      BuildContext context, String imageUrl, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        // Navigate to the corresponding page
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(3, 6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
