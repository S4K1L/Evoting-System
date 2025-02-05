import 'package:evotingsystem/controller/local_auth_api.dart';
import 'package:evotingsystem/utils/component/auth_button.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:evotingsystem/utils/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import '../../utils/constant/constant.dart';

class FingerprintPage extends StatefulWidget {
  const FingerprintPage({super.key});

  @override
  State<FingerprintPage> createState() => _FingerprintPageState();
}

class _FingerprintPageState extends State<FingerprintPage> {
  late bool isAvailable;
  late bool hasFingerprint;
  checkAvailable() async {
    isAvailable = await LocalAuthApi.hasBiometrics();
    final biometrics = await LocalAuthApi.getBiometrics();

    hasFingerprint = biometrics.contains(BiometricType.fingerprint);

    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildText('Biometrics', isAvailable),
        buildText('Fingerprint', hasFingerprint),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: kBackGroundColor,
    body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height/2.7,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white70,
                      child: Image.asset(logo)),
                ),
                Text(
                  "Login with your",
                  style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withOpacity(0.8)),
                ),
                Text(
                  "Fingerprint",
                  style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 10,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(35), topLeft: Radius.circular(35)),
                border: Border.all(color: Colors.transparent)),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text(
                    "Let us know it's you by one click authentication",
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.withOpacity(0.8)),
                  ),
                  LottieBuilder.asset(
                    "assets/fin.json",
                    repeat: true,
                  ),
                  FutureBuilder(
                      future: checkAvailable(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 2,
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // buildText('Biometrics Hardware  ', isAvailable),
                              buildText('Fingerprint Availability ', hasFingerprint),
                              authenticateButton(context)
                            ],
                          );
                        }
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}