import 'package:evotingsystem/controller/signup_controller.dart';
import 'package:evotingsystem/utils/component/custom_button.dart';
import 'package:evotingsystem/utils/component/input_form.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:evotingsystem/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Register extends StatelessWidget {
  Register({super.key});
  final SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: kPrimaryColor),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: kWhiteColor,
                  size: 28,
                ),
              )),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Image.asset(
                    logo,
                    height: MediaQuery.of(context).size.height / 2.8,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height/1.9,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      color: Colors.blue.withOpacity(0.3),
                    ),
                    child: Obx(()=>Skeletonizer(
                      enabled: signupController.isLoading.value,
                      enableSwitchAnimation: true,
                      child: Form(
                        key: signupController.formKey,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.arrow_drop_down,
                              color: kPrimaryColor,
                              size: 32,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding * 2, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InputForm(
                                    title: 'Enter your name',
                                    icon: Icons.person,
                                    controller: signupController.nameController.value,
                                  ),
                                  sizeBox,
                                  InputForm(
                                    title: 'Enter your phone',
                                    icon: Icons.phone,
                                    controller: signupController.phoneController.value,
                                  ),
                                  sizeBox,
                                  InputForm(
                                    title: 'Enter your email',
                                    icon: Icons.email,
                                    controller: signupController.emailController.value,
                                  ),
                                  sizeBox,
                                  InputForm(
                                    title: 'Enter your password',
                                    icon: Icons.password,
                                    controller: signupController.passwordController.value,
                                  ),
                                  sizeBox,
                                  CustomButton(
                                    title: 'Register',
                                    onPress: () {
                                      String email = signupController.emailController.value.text;
                                      String password = signupController.passwordController.value.text;
                                      signupController.signUp(email, password);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),),
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(redPlane),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
