import 'package:evotingsystem/controller/local_auth_api.dart';
import 'package:evotingsystem/view/FingerPrint_Authenticate/verfiy_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget authenticateButton(context) {
  return Container(
    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
    width: MediaQuery.of(context).size.width * 0.4,
    child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 0, backgroundColor: Colors.white,
          minimumSize: const Size.fromHeight(40),
        ),
        icon: const Icon(
          Icons.fingerprint,
          size: 26,
          color: Color(0xFF009C10),
        ),
        label: const Text(
          "Verify",
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF009C10),
          ),
        ),
        onPressed: () async {
          final isAuthenticated = await LocalAuthApi.authenticate();

          if (isAuthenticated) {
            Get.offAll(() => const FingerPrintVerify());
          }
        }),
  );
}
