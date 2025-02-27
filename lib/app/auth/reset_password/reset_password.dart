import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'CodeVerificationPage.dart';

class UsernameResetPage extends StatefulWidget {
  const UsernameResetPage({Key? key}) : super(key: key);

  @override
  _UsernameResetPageState createState() => _UsernameResetPageState();
}

class _UsernameResetPageState extends State<UsernameResetPage> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  Future<void> sendVerificationCode(String phone) async {
    final url = Uri.parse("https://portal.ahmed-hussain.com/api/patient/auth/forget-password");

    try {
      final response = await http.post(url, body: {"phone": phone});
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse["status"] == true) {
          // Get the original API message.
          String message = jsonResponse["message"];
          // Remove any trailing digits (verification code) from the message.
          String cleanMessage = message.replaceAll(RegExp(r'\d+$'), '').trim();

          // Show the cleaned message to the user.
          VxToast.show(context, msg: cleanMessage);

          // Navigate to the CodeVerificationPage and pass the phone number.
          Get.to(() => CodeVerificationPage(username: phone));
        } else {
          VxToast.show(context, msg: jsonResponse["message"] ?? "Error occurred");
        }
      } else {
        VxToast.show(context, msg: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      VxToast.show(context, msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Reset Password".text.make(),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Container(
        width: context.screenWidth,
        height: context.screenHeight,

        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  "Reset Password".text.xl2.bold.make().pOnly(bottom: 16),
                  "Enter your phone number to receive a verification code."
                      .text
                      .sm
                      .make()
                      .pOnly(bottom: 16),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ).pOnly(bottom: 16),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                      String phone = phoneController.text;
                      if (phone.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        await sendVerificationCode(phone);
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        VxToast.show(context,
                            msg: "Please enter a phone number");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
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
                        : "Send Verification Code".text.make(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
