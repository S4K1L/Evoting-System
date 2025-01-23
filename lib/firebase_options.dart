// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA4oFE-IQUso1vwta-ma0HZClxQm4eMEZM',
    appId: '1:632887560176:web:9555e7845c6c997258ff35',
    messagingSenderId: '632887560176',
    projectId: 'evote-25fff',
    authDomain: 'evote-25fff.firebaseapp.com',
    storageBucket: 'evote-25fff.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKvdey2PvpvQHUMkSj2CyANM5xChuY4Ew',
    appId: '1:632887560176:android:9bb2b0a94339c18d58ff35',
    messagingSenderId: '632887560176',
    projectId: 'evote-25fff',
    storageBucket: 'evote-25fff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNeXTnF8no4lvCz0Ab-mhq7FG-ysflZxE',
    appId: '1:632887560176:ios:d67df0ae1c35fe4958ff35',
    messagingSenderId: '632887560176',
    projectId: 'evote-25fff',
    storageBucket: 'evote-25fff.appspot.com',
    iosBundleId: 'com.s4k1l.evote',
  );
}
