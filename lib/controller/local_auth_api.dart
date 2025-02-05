import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  // Check if biometrics is available and the device has enrolled biometrics
  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      print("Error checking biometrics: $e");
      return false;
    }
  }

  // Get a list of available biometric types
  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print("Error getting biometrics: $e");
      return <BiometricType>[];
    }
  }

  // Authenticate using biometrics
  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) {
      print("Biometrics not available or not supported on this device.");
      return false;
    }

    try {
      return await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          biometricOnly: true, // Ensure only biometrics are used
          useErrorDialogs: true, // Show default system error messages
          stickyAuth: true, // Keeps the authentication active
        ),
      );
    } on PlatformException catch (e) {
      print("Authentication error: $e");
      return false;
    }
  }
}
