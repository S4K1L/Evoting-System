import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:evotingsystem/controller/login_controller.dart';
import 'package:evotingsystem/utils/component/custom_button.dart';
import 'package:evotingsystem/utils/component/custom_text_botton.dart';
import 'package:evotingsystem/utils/component/input_form.dart';
import 'package:evotingsystem/view/user_panel/register/register.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final LoginController loginController = Get.put(LoginController());
  final TextEditingController nidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: Stack(
        children: [
          // Top pinkish-red background with icons
          Container(
            height: MediaQuery.of(context).size.height / 1.6,
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
                Positioned(
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 80.sp),
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
                ),
              ],
            ),
          ),

          // Login form
          Align(
            alignment: Alignment.center,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width / 1.1,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 20.sp),
                  InputForm(
                    title: 'NID',
                    icon: Icons.person,
                    controller: nidController,
                    obscureText: false,
                  ),
                  SizedBox(height: 16),
                  InputForm(
                    title: 'Password',
                    icon: Icons.lock,
                    controller: passwordController,
                    obscureText: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    title: 'Login',
                    onPress: () {
                      loginController.login(
                        nidController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: CustomTextButton(
                firstText: "Don't have an account? ",
                secondText: 'Register',
                onPress: () {
                  Get.to(() => Register(), transition: Transition.rightToLeft);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
