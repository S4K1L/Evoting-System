import 'package:evotingsystem/controller/signup_controller.dart';
import 'package:evotingsystem/utils/component/custom_button.dart';
import 'package:evotingsystem/utils/component/input_form.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:evotingsystem/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Register extends StatelessWidget {
  Register({super.key});
  final SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height /1.6,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 16,
                  child: Icon(
                    Icons.circle,
                    color: Colors.white.withOpacity(0.3),
                    size: 40,
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  child: Icon(
                    Icons.circle,
                    color: Colors.white.withOpacity(0.3),
                    size: 40,
                  ),
                ),
                Positioned(
                  top: 168,
                  right: 40,
                  child: Icon(
                    Icons.circle,
                    color: Colors.white.withOpacity(0.3),
                    size: 40,
                  ),
                ),
                Positioned(
                  bottom: 36,
                  right: 0,
                  child: Icon(
                    Icons.circle,
                    color: Colors.white.withOpacity(0.3),
                    size: 40,
                  ),
                ),
                Positioned(
                  top: 48,
                  right: 24,
                  child: Icon(
                    Icons.circle,
                    color: Colors.white.withOpacity(0.3),
                    size: 60,
                  ),
                ),
                Positioned(
                  top: 88,
                  left: 28,
                  child: Icon(
                    Icons.circle,
                    color: Colors.white.withOpacity(0.3),
                    size: 60,
                  ),
                ),
                Positioned(
                  top: 119,
                  left: 28,
                  child: Icon(
                    Icons.circle,
                    color: Colors.white.withOpacity(0.3),
                    size: 60,
                  ),
                ),
                Positioned(
                  top: 98,
                  left: 48,
                  child: Icon(
                    Icons.circle,
                    color: Colors.white.withOpacity(0.3),
                    size: 60,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Logo Section
                Padding(
                  padding: EdgeInsets.only(top: 20*4.sp),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'E - VOTING',
                          style: TextStyle(
                            color: kWhiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          'SYSTEM',
                          style: TextStyle(
                            color: kWhiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Register Form Container
                Padding(
                  padding: EdgeInsets.only(top: 20*3.sp),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Obx(() => Skeletonizer(
                      enabled: signupController.isLoading.value,
                      enableSwitchAnimation: true,
                      child: Form(
                        key: signupController.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 20.sp),

                            // Name Input
                            InputForm(
                              title: 'Enter your name',
                              icon: Icons.person,
                              controller: signupController.nameController.value,
                              obscureText: false,
                            ),
                            const SizedBox(height: 20),

                            // Phone Input
                            InputForm(
                              title: 'Enter your phone',
                              icon: Icons.phone,
                              controller: signupController.phoneController.value,
                              obscureText: false,
                            ),
                            const SizedBox(height: 20),

                            // NID Input
                            InputForm(
                              title: 'Enter your NID',
                              icon: Icons.admin_panel_settings_sharp,
                              controller: signupController.nidController.value,
                              obscureText: false,
                            ),
                            const SizedBox(height: 20),

                            // Password Input
                            InputForm(
                              title: 'Enter your password',
                              icon: Icons.lock,
                              controller: signupController.passwordController.value,
                              obscureText: true,
                            ),
                            const SizedBox(height: 30),

                            // Register Button
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                title: 'Register',
                                onPress: () {
                                  String nid = signupController.nidController.value.text;
                                  String password = signupController.passwordController.value.text;
                                  signupController.signUp(nid, password);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ),
                ),
                const SizedBox(height: 20),
                // Bottom Design and Navigation Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.black87,fontSize: 18.sp),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}