import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'NewPasswordPage.dart';

class CodeVerificationPage extends StatefulWidget {
  final String username;
  const CodeVerificationPage({Key? key, required this.username})
      : super(key: key);

  @override
  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  Future<void> verifyCode() async {
    final url = Uri.parse("https://portal.ahmed-hussain.com/api/patient/auth/check-otp");
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(url, body: {
        "phone": widget.username,
        "code": codeController.text,
      });
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse["status"] == true) {
          VxToast.show(context, msg: jsonResponse["message"] ?? "Recovery code is valid.");
          // Navigate to the NewPasswordPage with phone and otp.
          Get.to(() => NewPasswordPage(
            username: widget.username,
            otp: codeController.text,
          ));
        } else {
          VxToast.show(context, msg: jsonResponse["message"] ?? "Incorrect verification code");
        }
      } else {
        VxToast.show(context, msg: "Server error: ${response.statusCode}");
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
      backgroundColor: Colors.white, // Professional white background.
      appBar: AppBar(
        title: const Text('Reset Password - Step 2: Enter Code'),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                "Enter Verification Code".text.xl2.bold.make().pOnly(bottom: 16),
                "Please enter the recovery code sent to your phone."
                    .text.sm.make()
                    .pOnly(bottom: 16),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.code),
                    labelText: 'Verification Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ).pOnly(bottom: 16),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    if (codeController.text.isNotEmpty) {
                      verifyCode();
                    } else {
                      VxToast.show(context, msg: "Please enter the code");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                      : "Verify Code".text.make(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
