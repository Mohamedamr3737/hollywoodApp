import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../view/login_page.dart';

class NewPasswordPage extends StatefulWidget {
  final String username;
  final String otp;
  const NewPasswordPage({Key? key, required this.username, required this.otp})
      : super(key: key);

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool isLoading = false;

  Future<void> updatePassword() async {
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      VxToast.show(context, msg: "Please fill out both password fields");
      return;
    }
    if (newPassword != confirmPassword) {
      VxToast.show(context, msg: "Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        "https://portal.ahmed-hussain.com/api/patient/auth/forget-password-reset");

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "phone": widget.username,
            "code": widget.otp,
            "password": newPassword,
            "password_confirmation": confirmPassword,
          }));

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse["status"] == true) {
        VxToast.show(context, msg: "Password updated successfully!");
        // Navigate to the login page.
        Get.offAll(() => LoginView());
      } else {
        // Handle error response.
        String errorMessage = "";
        if (jsonResponse["message"] is Map) {
          jsonResponse["message"].forEach((key, value) {
            errorMessage += (value is List ? value.join(", ") : value) + "\n";
          });
        } else {
          errorMessage =
              jsonResponse["message"] ?? "Failed to update password.";
        }
        VxToast.show(context, msg: errorMessage);
      }
    } catch (e) {
      VxToast.show(context, msg: "Error: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reset Password - Step 3: New Password'),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Enter New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                labelText: 'Re-enter New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isLoading ? null : updatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
}
