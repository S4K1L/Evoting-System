import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:evotingsystem/utils/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class FingerPrintVerify extends StatefulWidget {
  const FingerPrintVerify({super.key});

  @override
  _FingerPrintVerifyState createState() => _FingerPrintVerifyState();
}

class _FingerPrintVerifyState extends State<FingerPrintVerify> {
  @override
  void initState() {
    super.initState();
    // Delaying navigation to HomePage after 3 seconds
    Future.delayed(const Duration(seconds: 4), () {
      _route();
    });
  }

  void _route() async {
    User? user = FirebaseAuth.instance.currentUser;

    var documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    if (documentSnapshot.exists) {
      String userType = documentSnapshot.get('role');
      if (userType == "user") {
        Get.snackbar(
          'Login Success',
          'You have successfully logged in!',
          colorText: kWhiteColor,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
        );
        Get.toNamed(RoutesPath.userBottomBar);
      }
      else if (userType == "admin") {
        Get.snackbar(
          'Login Success',
          'You have successfully logged in!',
          colorText: kWhiteColor,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
        );
        Get.toNamed(RoutesPath.adminHome);
      }
      else {
        Get.snackbar(
          'Try again',
          'Some error in logging in!',
          colorText: kWhiteColor,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
        );
      }
    }
    else {
      print('user data not found');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.25),
            child: Lottie.asset("assets/fin2.json", repeat: false),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: Text(
              "Verify Successfully",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 22,
                color: Color(0xFF009C10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
