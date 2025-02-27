import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/session_controller.dart';
import 'sessionByRegionPage.dart';
import '../../../auth/controller/token_controller.dart';

class MySessionsPage extends StatelessWidget {
  const MySessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the controller is initialized properly
    checkLoginStatus();
    final SessionController sessionController = Get.put(SessionController());

    // Explicitly call fetchSessions() in case onInit is not called
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sessionController.fetchSessions();
    });

    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    Widget _buildSessionOption(BuildContext context, String imageUrl,
        String label, double screenWidth, int regionId) {
      double iconSize = screenWidth * 0.3;
      double fontSize = screenWidth * 0.04;

      return GestureDetector(
        onTap: () {
          Get.to(() => SessionListPage(regionId: regionId, regionName: label));
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

    return Scaffold(
      body: Column(
        children: [
          // **1️⃣ AppBar at the Top**
          AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.orangeAccent),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text(
              "My Sessions",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),

          // **2️⃣ Stack for Background & Circular Image**
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Image.network(
                'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRElHzS7DF6u04X-Y0OPLE2YkIIcaI6XjbB5K5atLN_ZCPg_Un9',
                height: screenHeight * 0.25,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
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
            ],
          ),

          // **3️⃣ Space Below Circular Image to Prevent Overlap**
          const SizedBox(height: 50),

          // **4️⃣ Expanded Section for the Session List**
          Expanded(
            child: Obx(() {
              if (sessionController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (sessionController.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    sessionController.errorMessage.value,
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                );
              }

              if (sessionController.regions.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.event_note, size: 100, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text(
                      "No Sessions Available",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.04,
                  mainAxisSpacing: screenHeight * 0.03,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: sessionController.regions
                      .map((session) => _buildSessionOption(
                    context,
                    session["icon"] ?? "",
                    session["title"] ?? "",
                    screenWidth,
                    session['id'] ?? "",
                  ))
                      .toList(),
                ),
              );
            }),
          ),
        ],
      ),
    );

  }
}