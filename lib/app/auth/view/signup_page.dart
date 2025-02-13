import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_medi/app/auth/controller/signup_controller.dart';
import 'package:s_medi/app/home/view/home.dart';
import 'package:s_medi/app/widgets/coustom_textfield.dart';
import 'package:s_medi/app/widgets/loading_indicator.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SignupController());
    return Scaffold(
      body: Stack(
        children: [
          // Background and image with no space at the top
          Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50), // Semi-circle effect
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://st5.depositphotos.com/62628780/65781/i/450/depositphotos_657816120-stock-photo-natural-hair-sunflower-portrait-black.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // AppBar positioned at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: const Color.fromARGB(255, 3, 23, 40)
                  .withOpacity(0.8), // Dark overlay
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.orangeAccent,
                ),
                onPressed: () {
                  Navigator.pop(context); // Navigates back
                },
              ),
              title: const Text(
                'Signup',
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          // Main content
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.28,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome To Hollywood Clinic',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Form(
                      key: controller.formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CoustomTextField(
                              textcontroller: controller.nameController,
                              hint: "Full Name",
                              icon: const Icon(Icons.person),
                              validator: controller.validateName,
                            ),
                            const SizedBox(height: 15),
                            CoustomTextField(
                              textcontroller: controller.phoneController,
                              icon: const Icon(Icons.phone),
                              hint: "Phone Number",
                              validator: controller.validatePhone,
                            ),
                            const SizedBox(height: 15),
                            CoustomTextField(
                              textcontroller: controller.emailController,
                              icon: const Icon(Icons.email_outlined),
                              hint: "Email",
                              validator: controller.validateEmail,
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              hint: const Text("Select Gender"),
                              items: ['Male', 'Female', 'Other']
                                  .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                controller.selectedGender.value = value!;
                              },
                              validator: (value) => value == null
                                  ? 'Please select a gender'
                                  : null,
                            ),
                            const SizedBox(height: 15),
                            CoustomTextField(
                              textcontroller: controller.passwordController,
                              icon: const Icon(Icons.lock),
                              hint: "Password",
                              validator: controller.validatePassword,
                            ),
                            const SizedBox(height: 15),
                            CoustomTextField(
                              textcontroller:
                              controller.confirmPasswordController,
                              icon: const Icon(Icons.lock),
                              hint: "Confirm Password",
                              validator: controller.validateConfirmPassword,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "By creating an account, you agree to our terms of service and privacy policy and you will receive a confirmation code on your mobile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 44,
                              child: Obx(
                                    () => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color.fromARGB(255, 3, 23, 40),
                                    shape: const StadiumBorder(),
                                  ),
                                  onPressed: () async {
                                    await controller.signupUser(context);
                                  },
                                  child: controller.isLoading.value
                                      ? const LoadingIndicator()
                                      : const Text(
                                    'Continue',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
