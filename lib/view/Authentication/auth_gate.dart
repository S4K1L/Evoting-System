import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:evotingsystem/utils/routes/routes.dart';
import 'package:evotingsystem/view/FingerPrint_Authenticate/fingerprint_scanner_ui.dart';
import 'package:evotingsystem/view/user_panel/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: LiquidCircularProgressIndicator(
                  value: 0.25,
                  valueColor: const AlwaysStoppedAnimation(Colors.blue),
                  backgroundColor: Colors.white,
                  borderColor: Colors.blue,
                  borderWidth: 5.0,
                  direction: Axis.vertical,
                  center: const Text("Loading..."),
                ),
              ),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            return const FingerprintPage();
          } else {
            return Login();
          }
        },
      ),
    );
  }


}
