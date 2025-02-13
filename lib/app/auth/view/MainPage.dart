// lib/app/main/view/main_page.dart

// ignore_for_file: unused_import, file_names, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:s_medi/about/about.dart';
import 'package:s_medi/app/auth/view/MyServicesPage.dart' as auth;
import 'package:s_medi/app/auth/view/ShopPage.dart';
import 'package:s_medi/app/home/view/home_screen.dart';
import 'package:s_medi/serv/servicespage.dart';
import 'package:s_medi/app/home/view/home.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2; // Default to "Home" tab

  // List of pages for each tab
  final List<Widget> _pages = [
    ServicesPage(),
    AboutPage(),
    HomePage(), // Replace with your Home page widget
    ShopPage(), // Replace with your Shop page widget
    auth.MySessionsPage(), // Use the prefix 'auth' to specify the correct MySessionsPage
  ];

  // Update the selected index and rebuild with setState
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0), // Makes the top corners rounded
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Services',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              label: 'About',
            ),
            BottomNavigationBarItem(
              icon: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQa85Mr3rqsBeXwpHZKrCQiyIXjXySFQIRkWBCkpbMXXHPfkps",
                width: 30, // Adjust the width as needed
                height: 30, // Adjust the height as needed
                fit: BoxFit.contain,
              ),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'Shop',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              label: 'My Sessions',
            ),
          ],
        ),
      ),
    );
  }
}
