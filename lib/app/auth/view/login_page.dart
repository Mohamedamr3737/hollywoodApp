// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:s_medi/about/about.dart';
import 'package:s_medi/app/auth/controller/login_controller.dart';
import 'package:s_medi/app/auth/view/MainPage.dart';
// ignore: unused_import
import 'package:s_medi/app/widgets/coustom_textfield.dart';
import 'package:s_medi/general/consts/consts.dart';
import 'package:s_medi/serv/servicespage.dart';
import '../reset_password/reset_password.dart';
import '../../widgets/loading_indicator.dart';
import 'signup_page.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f6),
      body: Container(
        margin: const EdgeInsets.only(top: 35),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Column(
              children: [
                // Image section with semi-circle effect at the bottom
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        Radius.circular(50), // Creates the semi-circle effect
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height *
                        0.45, // 50% of the screen height
                    width: double.infinity, // Full width of the screen
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://st5.depositphotos.com/62628780/65781/i/450/depositphotos_657816120-stock-photo-natural-hair-sunflower-portrait-black.jpg', // Network image URL
                        ),
                        fit: BoxFit
                            .cover, // Ensures the image covers the container fully
                      ),
                    ),
                  ),
                ),
                // Space between image and text
                SizedBox(height: 16),
                // Welcome text section
                Text(
                  'Welcome to Hollywood Clinic',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            15.heightBox,
            Expanded(
              flex: 2,
              child: Form(
                  key: controller.formkey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CoustomTextField(
                          validator: controller
                              .validateemail, // Use a phone number validation logic if needed
                          textcontroller: controller
                              .emailController, // Or you could rename this to something like phoneController if more appropriate
                          icon:
                              const Icon(Icons.phone), // Changed to phone icon
                          hint:
                              "Enter your phone number", // Changed hint to "Enter your phone number"
                        ),
                        18.heightBox,
                        CoustomTextField(
                          validator: controller.validpass,
                          textcontroller: controller.passwordController,
                          icon: const Icon(Icons.key),
                          hint: AppString.passwordHint,
                        ),
                        20.heightBox,
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: () {
                                Get.to(() => const UsernameResetPage());
                              },
                              child: "Forget Password ?".text.make()),
                        ),
                        20.heightBox,
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.9, // Match the width of the text field
                          height: 44,
                          child: Obx(
                            () => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () async {
                                await controller.loginUser(context);
                                // Check if the login was successful (i.e., the loginUser method completed successfully)
                                // if (controller.isLoading.isFalse) {
                                //   // Navigate to the home screen after a successful login
                                //   Get.offAll(() => const Home());
                                // }
                              },
                              child: controller.isLoading.value
                                  ? const LoadingIndicator()
                                  : AppString.login.text.white.make(),
                            ),
                          ),
                        ),
                        20.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppString.dontHaveAccount.text.make(),
                            10.widthBox,
                            AppString.signup.text
                                .color(const Color.fromARGB(255, 2, 39, 69))
                                .make()
                                .onTap(() {
                              Get.to(() => const SignupView());
                            }),
                          ],
                        )
                      ],
                    ),
                  )),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Services icon and label
                  GestureDetector(
                    onTap: () {
                      // Navigate to ServicesPage when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ServicesPage()),
                      );
                      // Or if you're using GetX, you can use:
                      // Get.to(() => ServicesPage());
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.group, color: Colors.black),
                        SizedBox(height: 4),
                        Text("Services", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),

                  // Center icon
                  // Center icon
                  // Center icon
                  GestureDetector(
                    onTap: () {
                      // Navigate to MainPage when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 28,
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQa85Mr3rqsBeXwpHZKrCQiyIXjXySFQIRkWBCkpbMXXHPfkps',
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // About icon and label
                  GestureDetector(
                    onTap: () {
                      // Navigate to About Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info, color: Colors.black),
                        SizedBox(height: 4),
                        Text("About", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
