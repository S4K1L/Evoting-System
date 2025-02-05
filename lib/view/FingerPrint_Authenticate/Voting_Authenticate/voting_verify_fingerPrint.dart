import 'package:evotingsystem/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VotingFingerPrintVerify extends StatefulWidget {
  const VotingFingerPrintVerify({super.key});

  @override
  _VotingFingerPrintVerifyState createState() => _VotingFingerPrintVerifyState();
}

class _VotingFingerPrintVerifyState extends State<VotingFingerPrintVerify> {
  @override
  void initState() {
    super.initState();
    // Delaying navigation to HomePage after 3 seconds
    Future.delayed(const Duration(seconds: 4), () {
      Get.toNamed(RoutesPath.userBottomBar);
    });
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
