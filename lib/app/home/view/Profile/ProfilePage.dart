// ignore_for_file: file_names, duplicate_import, duplicate_ignore, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/profile_controller.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController membershipController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  String profileImage = "https://portal.ahmed-hussain.com/no-image.png";

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProfileController>(context, listen: false).fetchProfile());
  }

  void updateProfile() async {
    final profileController =
    Provider.of<ProfileController>(context, listen: false);

    final updatedData = {
      "name": nameController.text,
      "gender": genderController.text, // Assuming gender remains unchanged
      "birthday": birthdayController.text,
      "email": emailController.text,
      "address": addressController.text,
    };

    await profileController.updateProfile(updatedData, context);

    if (profileController.errorMessage.isEmpty) {
      setState(() {
        isEditing = false; // Exit edit mode after successful update
      });
    } else {
      // Show error message if update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(profileController.errorMessage)),
      );
    }
  }

  void showChangePasswordDialog() {
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "New Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  Get.snackbar("Error", "All fields are required",
                      backgroundColor: Colors.red, colorText: Colors.white);
                  return;
                }

                if (passwordController.text != confirmPasswordController.text) {
                  Get.snackbar("Error", "Passwords do not match",
                      backgroundColor: Colors.red, colorText: Colors.white);
                  return;
                }

                // Get the existing profile data
                final profileController =
                Provider.of<ProfileController>(context, listen: false);

                // Prepare complete updated data with existing values
                Map<String, dynamic> updatedData = {
                  "name": profileController.userData?["name"] ?? "",
                  "gender": profileController.userData?["gender"] ?? "",
                  "birthday": profileController.userData?["birthday"] ?? "",
                  "email": profileController.userData?["email"] ?? "",
                  "address": profileController.userData?["address"] ?? "",
                  "password": passwordController.text,
                  "password_confirmation": confirmPasswordController.text,
                };

                // Send update request
                await profileController.updateProfile(updatedData, context);

                if (profileController.errorMessage.isEmpty) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);

    if (!profileController.isLoading && profileController.userData != null) {
      final userData = profileController.userData!;
      nameController.text = userData["name"] ?? "N/A";
      idController.text = userData["uid"] ?? "N/A";
      ageController.text = userData["age"]?.toString() ?? "N/A";
      birthdayController.text = userData["birthday"] ?? "N/A";
      emailController.text = userData["email"] ?? "N/A";
      membershipController.text = userData["membership"] ?? "N/A";
      addressController.text = userData["address"] ?? "N/A";
      genderController.text= userData['gender']?? "N/A";
      profileImage = userData["image"] ?? "https://portal.ahmed-hussain.com/no-image.png";
    }

    return Scaffold(
      body: profileController.isLoading
          ? const Center(child: CircularProgressIndicator())

          : Stack(
        children: [
          // Background image with AppBar overlay
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRElHzS7DF6u04X-Y0OPLE2YkIIcaI6XjbB5K5atLN_ZCPg_Un9',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 100), // Space for circular profile image
            ],
          ),
          // Positioned Circular Image
          Positioned(
            top: 140,
            left: MediaQuery.of(context).size.width / 2 - 70,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(profileImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            top: 280,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Center(
                  child: Text(
                    "Personal Info",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoField("Name", nameController),
                _buildInfoField("ID", idController, enabled: false),
                _buildInfoField("Age", ageController, enabled: false), // Age uneditable
                _buildInfoField("Birthday", birthdayController),
                _buildInfoField("Email", emailController),
                _buildInfoField("Gender", genderController),
                _buildInfoField("Membership", membershipController, enabled: false),
                _buildInfoField("Address", addressController),
                const SizedBox(height: 30),
                if (isEditing)
                  ElevatedButton(
                    onPressed: updateProfile,
                    child: const Text("Save Changes"),
                  ),
                const Divider(),
                ListTile(
                  title: const Text(
                    "Change Password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Change password logic
                    showChangePasswordDialog();
                  },
                ),
                ListTile(
                  title: const Text(
                    "Delete Account",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    // Delete account logic
                    // Show confirmation dialog before deletion.
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm Deletion"),
                          content: const Text("Are you sure you want to delete your account? This action cannot be undone."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false); // Cancel deletion.
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(true); // Confirm deletion.
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      await Provider.of<ProfileController>(context, listen: false)
                          .deleteAccount(context);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    await Provider.of<ProfileController>(context, listen: false)
                        .signOut(context);                  },
                ),
              ],
            ),
          ),
          // Black AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.orangeAccent),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: const Text(
                "My Profile",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    isEditing ? Icons.check : Icons.edit,
                    color: Colors.orangeAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      if(isEditing){
                        updateProfile();
                      }
                      isEditing = !isEditing;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            enabled: isEditing && enabled,
            decoration: InputDecoration(
              filled: true,
              fillColor: isEditing && enabled ? Colors.white : Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            style: TextStyle(color: isEditing && enabled ? Colors.black87 : Colors.grey),
          ),
        ],
      ),
    );
  }
}
