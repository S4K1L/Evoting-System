import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evotingsystem/model/user_model.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:evotingsystem/utils/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';


class SignupController extends GetxController {
  final nameController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final nidController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();

  // Firestore and FirebaseAuth instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Model
  var userModel = UserModel().obs;
  RxBool isLoading = false.obs;

  Future<UserModel?> signUp(String nid, String password) async {
    isLoading.value = true;
    String email = "$nid@gmail.com";
    try {
      // Validate the form
      if (!formKey.currentState!.validate()) {
        // Form is invalid, show error
        isLoading.value = false;
        Get.snackbar(
          'Invalid Input',
          'Please check your all data',
          colorText: kWhiteColor,
          backgroundColor: kPrimaryColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
        );
        return null;
      } else {
        // Form is valid, proceed with sign-up
        UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = result.user;

        if (user != null) {
          // Create a UserModel object
          userModel.value = UserModel(
            name: nameController.value.text,
            phone: phoneController.value.text,
            nid: nidController.value.text,
            password: passwordController.value.text,
            fingerPrint: true,
          );

          // Store user information in Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'name': userModel.value.name,
            'nid': userModel.value.nid,
            'password': userModel.value.password,
            'phone': userModel.value.phone,
            'role': 'user',
            'uid': user.uid,
            'fingerPrint': userModel.value.fingerPrint,
          });

          isLoading.value = false;
          // Success message
          Get.snackbar(
            'Registration Successful',
            'Welcome to eVote',
            colorText: kWhiteColor,
            backgroundColor: kPrimaryColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
          );
          Get.toNamed(RoutesPath.userBottomBar);
          return userModel.value;
        } else {
          isLoading.value = false;
          Get.snackbar('Registration Failed!', 'Try again!',
              colorText: kWhiteColor,
              backgroundColor: kPrimaryColor,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16));
          if (kDebugMode) {
            print("User is null");
          }
          return null;
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print("Error in registering: $e");
      }
      Get.snackbar(
        'Error',
        'Registration failed: $e',
        colorText: kWhiteColor,
        backgroundColor: kPrimaryColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );
      return null;
    }
  }



}