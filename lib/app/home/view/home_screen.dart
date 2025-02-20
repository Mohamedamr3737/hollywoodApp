import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_medi/app/home/view/AppointmentsPage.dart';
import 'package:s_medi/app/home/view/BalancePage.dart';
import 'package:s_medi/app/home/view/MyOrderPage.dart';
import 'package:s_medi/app/home/view/PrescriptionPage.dart';
import 'package:s_medi/app/home/view/ProfilePage.dart';
import 'package:s_medi/app/home/view/SpecialOffersPage.dart';
import './MySessionsPage.dart';
import 'package:s_medi/app/home/view/mydata.dart';
import 'package:s_medi/app/home/view/request.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

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
                height: screenHeight * 0.25, // 25% of screen height
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              // Circle profile icon
              Positioned(
                bottom: -screenHeight * 0.06, // Adjust based on screen size
                child: Container(
                  width: screenWidth * 0.35, // 35% of screen width
                  height: screenWidth * 0.35,
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
          SizedBox(height: screenHeight * 0.08), // Adjust spacing dynamically
          // Grid of clickable options
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(screenWidth * 0.04), // Scalable padding
              crossAxisSpacing: screenWidth * 0.04,
              mainAxisSpacing: screenHeight * 0.03,
              children: [
                _buildOption(
                  context,
                  "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTrKVYM6Ttou8JcXZUDH5MJfUpVg4up-jZUUxeHiu-QQpcRtsd7",
                  "My Profile",
                  const ProfilePage(),
                  screenWidth,
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSQyZNKxW9s5lEyrUlJKYIsVKzT4dbuLWHyNIhrO00viFluxBwZ",
                  "My Sessions",
                  const MySessionsPage(),
                  screenWidth,
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJvshuC7e14u93nb1z_g4S1kvAIm86R0gQF-Zq4Iwq6-fZL4eY",
                  "Appointments",
                  const AppointmentsPage(),
                  screenWidth,
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcT5-LAPHBq67t8jlkeQ3IkUcNbPVuvQvt8R7dQUxqG1eTbKiRJa",
                  "My Balance",
                  const MyBalancePage(),
                  screenWidth,
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTE99tUgRwxcKQAWpnqMpWk69e2CvXj0NMIF6Img4DiU3pPsi0X",
                  "Special Offers",
                  const SpecialOffersPage(),
                  screenWidth,
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRXi5xyC8STTuAtazhR44tMHwxldphRmj9zzNRtK9X23n-_p93k",
                  "My Order",
                  const MyOrdersPage(),
                  screenWidth,
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTusZ1LSpUqvBE3uLFQ3Y9oxEGt8nck4oJRRE3hm5xJEfs9F-An",
                  "Prescription",
                  const PrescriptionPage(),
                  screenWidth,
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTusZ1LSpUqvBE3uLFQ3Y9oxEGt8nck4oJRRE3hm5xJEfs9F-An",
                  "My Data",
                  const MyDataPage(),
                  screenWidth,
                ),
                _buildOption(
                  context,
                  "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTusZ1LSpUqvBE3uLFQ3Y9oxEGt8nck4oJRRE3hm5xJEfs9F-An",
                  "My Requests",
                  const MyRequestsPage(category: '',),
                  screenWidth,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build each icon option with scalable sizing
  Widget _buildOption(BuildContext context, String imageUrl, String label, Widget page, double screenWidth) {
    double iconSize = screenWidth * 0.3; // 30% of screen width for icons
    double fontSize = screenWidth * 0.04; // 4% of screen width for text

    return GestureDetector(
      onTap: () {
        // Navigate to the corresponding page
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
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
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
