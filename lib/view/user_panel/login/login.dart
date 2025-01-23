import 'package:evote/controller/login_controller.dart';
import 'package:evote/utils/component/custom_button.dart';
import 'package:evote/utils/component/custom_text_botton.dart';
import 'package:evote/utils/component/input_form.dart';
import 'package:evote/utils/constant/colors.dart';
import 'package:evote/utils/constant/constant.dart';
import 'package:evote/view/user_panel/register/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final LoginController loginController = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Image.asset(
                    logo,
                    height: MediaQuery.of(context).size.height / 2.2,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      color: Colors.blue.withOpacity(0.3),
                    ),
                    child: Obx(
                      () => Skeletonizer(
                        enabled: loginController.isLoading.value,
                        enableSwitchAnimation: true,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.arrow_drop_down,
                              color: kPrimaryColor,
                              size: 32,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding * 2,
                                  vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InputForm(
                                    title: 'Enter your email',
                                    icon: Icons.email,
                                    controller: emailController,
                                  ),
                                  sizeBox,
                                  InputForm(
                                    title: 'Enter your password',
                                    icon: Icons.password,
                                    controller: passwordController,
                                  ),
                                  const SizedBox(
                                    height: kDefaultPadding * 2,
                                  ),
                                  CustomButton(
                                    title: 'Login',
                                    onPress: () {
                                      loginController.login(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                    },
                                  ),
                                  sizeBox,
                                  CustomTextButton(
                                    firstText: "Don't have an account?  ",
                                    secondText: 'Register here',
                                    onPress: () {
                                      Get.to(() => Register(),
                                          transition: Transition.leftToRight);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 10,
                left: 50,
                right: -60,
                child: Image.asset(plane),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
