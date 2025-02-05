import 'package:evotingsystem/utils/widgets/user_bottom_bar.dart';
import 'package:evotingsystem/view/FingerPrint_Authenticate/fingerprint_scanner_ui.dart';
import 'package:evotingsystem/view/user_panel/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<bool?> _checkFingerprintStatus(String uid) async {
    try {
      // Fetch the user document from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // Check if the 'fingerPrint' field exists in the user document
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('fingerPrint')) {
          return userData['fingerPrint']
              as bool; // Return the fingerprint status
        }
      }
      return null; // Return null if no user data or 'fingerPrint' not found
    } catch (e) {
      print('Error checking fingerprint status: $e');
      return null;
    }
  }

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
                  // Defaults to 0.5.
                  valueColor: const AlwaysStoppedAnimation(Colors.blue),
                  // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors.white,
                  // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.blue,
                  borderWidth: 5.0,
                  direction: Axis.vertical,
                  // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                  center: const Text("Loading..."),
                ),
              ),
            ); // Show loading indicator
          }

          if (snapshot.hasData && snapshot.data != null) {
            User user = snapshot.data!;

            // Check fingerprint status from Firestore for the logged-in user
            return FutureBuilder<bool?>(
              future: _checkFingerprintStatus(user.uid),
              builder: (context, fingerprintSnapshot) {
                if (fingerprintSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: LiquidCircularProgressIndicator(
                        value: 0.25,
                        // Defaults to 0.5.
                        valueColor: const AlwaysStoppedAnimation(Colors.blue),
                        // Defaults to the current Theme's accentColor.
                        backgroundColor: Colors.white,
                        // Defaults to the current Theme's backgroundColor.
                        borderColor: Colors.blue,
                        borderWidth: 5.0,
                        direction: Axis.vertical,
                        // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                        center: const Text("Loading..."),
                      ),
                    ),
                  ); // Show loading indicator
                }

                if (fingerprintSnapshot.hasData) {
                  bool? isFingerprintEnabled = fingerprintSnapshot.data;

                  if (isFingerprintEnabled == true) {
                    return const FingerprintPage();
                  } else if (isFingerprintEnabled == false) {
                    return const UserBottomBar();
                  }
                }
                return Login();
              },
            );
          } else {
            // User is not logged in, go to LoginPage
            return Login();
          }
        },
      ),
    );
  }
}
