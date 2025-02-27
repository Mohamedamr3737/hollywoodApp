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
import 'package:s_medi/app/home/view/SelectCategoryRequestPage.dart';
import 'NotificationsPage.dart';
import '../controller/notifications_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationsController _notificationsController = Get.find<NotificationsController>();

  @override
  void initState() {
    super.initState();
    // Fetch the initial unread count
    _notificationsController.fetchUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Upper background image
                Image.network(
                  'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRElHzS7DF6u04X-Y0OPLE2YkIIcaI6XjbB5K5atLN_ZCPg_Un9',
                  height: screenHeight * 0.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Circle profile icon
                Positioned(
                  bottom: -screenHeight * 0.06,
                  child: Container(
                    width: screenWidth * 0.35,
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
                // Notifications Icon with reactive badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: Obx(() {
                    int count = _notificationsController.unreadCount.value;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationsPage()),
                            );
                          },
                        ),
                        if (count > 0)
                          Positioned(
                            right: 0,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                count.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.08),
            // Grid of clickable options
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(screenWidth * 0.04),
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
                    MyBalancePage(),
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
                    const SelectCategoryPage(),
                    screenWidth,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build each icon option with scalable sizing
  Widget _buildOption(
      BuildContext context,
      String imageUrl,
      String label,
      Widget page,
      double screenWidth,
      ) {
    double iconSize = screenWidth * 0.3;
    double fontSize = screenWidth * 0.04;

    return GestureDetector(
      onTap: () {
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
