// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_medi/about/about.dart';
// import 'package:s_medi/app/auth/view/MyServicesPage.dart';
import 'package:s_medi/app/home/view/ShopView.dart';
import 'package:s_medi/app/home/view/home_screen.dart'; // Assuming this is the main home screen widget
import 'package:s_medi/general/consts/colors.dart';

// Ensure the following imports are correct based on your file structure
import 'package:s_medi/serv/servicespage.dart';
import './MySessionsPage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 2; // Default to "Home" tab

  // Define the list of screens correctly
  List<Widget> screenList = [
    ServicesPage(), // Services page
    AboutPage(), // About page
    const HomePage(), // Main home screen widget
    const ShopView(), // Shop page
    const MySessionsPage(), // My Sessions page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black, // Change this to your desired color
        selectedItemColor: AppColors.primeryColor, // Selected item color
        unselectedItemColor:
            const Color.fromARGB(255, 0, 0, 0), // Unselected item color
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value; // Update index on tap
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Services",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: "About",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            label: "My Sessions",
          ),
        ],
      ),
    );
  }
}
