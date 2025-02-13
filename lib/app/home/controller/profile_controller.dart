import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controller/token_controller.dart';

class ProfileController with ChangeNotifier {
  String apiUrl = "https://portal.ahmed-hussain.com/api/patient/profile/me";
  String updateApiUrl = "https://portal.ahmed-hussain.com/api/patient/profile/update";

  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';

  Future<void> fetchProfile() async {
    try {
      if (await isTokenExpired()) {
        await refreshAccessToken();
      }
      String? token = await getAccessToken();

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userData = data['data'];
        errorMessage = '';
      } else {
        errorMessage = "Failed to fetch profile. Try again later.";
      }
    } catch (e) {
      errorMessage = "An error occurred: $e";
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> updatedData, BuildContext context) async {
    try {
      if (await isTokenExpired()) {
        await refreshAccessToken();
      }
      String? token = await getAccessToken();

      // Ensure passwords are included only if they are provided
      Map<String, dynamic> finalData = {
        "name": updatedData["name"],
        "gender": updatedData["gender"],
        "birthday": updatedData["birthday"],
        "email": updatedData["email"],
        "address": updatedData["address"],
      };

      if (updatedData.containsKey("password") && updatedData["password"].isNotEmpty) {
        finalData["password"] = updatedData["password"];
        finalData["password_confirmation"] = updatedData["password_confirmation"];
      }

      final response = await http.post(
        Uri.parse(updateApiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(finalData),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData["status"] == true) {
        fetchProfile(); // Refresh profile data
        errorMessage = '';

        // Show success message
        Get.snackbar(
          "Success",
          "Profile updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Handle API error response
        if (responseData["message"] is Map) {
          errorMessage = responseData["message"].values.join("\n"); // Combine all error messages
        } else {
          errorMessage = responseData["message"] ?? "Failed to update profile.";
        }

        // Show error message in Snackbar
        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage = "An error occurred: $e";

      Get.snackbar(
        "Error",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    notifyListeners(); // Ensure UI refreshes after update
  }

}
