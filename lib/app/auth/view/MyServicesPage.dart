// lib/app/sessions/view/my_sessions_page.dart

// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MySessionsPage extends StatelessWidget {
  const MySessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sessions'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Sessions Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Here you can view your upcoming sessions, session history, or book new sessions.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            // Add any session-related widgets here
          ],
        ),
      ),
    );
  }
}
