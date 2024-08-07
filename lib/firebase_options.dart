// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyDb8bxKaVa8oJkw5MjUsC-r1xdkcWbchx0',
    appId: '1:608917748421:web:647c7d27a4c5b55a53ceac',
    messagingSenderId: '608917748421',
    projectId: 'iot-energy-tracking-app',
    authDomain: 'iot-energy-tracking-app.firebaseapp.com',
    databaseURL: 'https://iot-energy-tracking-app-default-rtdb.firebaseio.com',
    storageBucket: 'iot-energy-tracking-app.appspot.com',
    measurementId: 'G-NTL6HGYKJE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9FR5T4T7u5Ch9Kv2redbYg6MyCTe_fpw',
    appId: '1:608917748421:android:e95920fa820a868f53ceac',
    messagingSenderId: '608917748421',
    projectId: 'iot-energy-tracking-app',
    databaseURL: 'https://iot-energy-tracking-app-default-rtdb.firebaseio.com',
    storageBucket: 'iot-energy-tracking-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDnWTrsLIxb5THPc74l4hw7qYISjgom1sg',
    appId: '1:608917748421:ios:07de8a200ea0f35853ceac',
    messagingSenderId: '608917748421',
    projectId: 'iot-energy-tracking-app',
    databaseURL: 'https://iot-energy-tracking-app-default-rtdb.firebaseio.com',
    storageBucket: 'iot-energy-tracking-app.appspot.com',
    iosClientId: '608917748421-onhnn1qfgv7tjnr3ig52fgl10u8eg0pj.apps.googleusercontent.com',
    iosBundleId: 'com.example.energyTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDnWTrsLIxb5THPc74l4hw7qYISjgom1sg',
    appId: '1:608917748421:ios:7d7141c7d75267bc53ceac',
    messagingSenderId: '608917748421',
    projectId: 'iot-energy-tracking-app',
    databaseURL: 'https://iot-energy-tracking-app-default-rtdb.firebaseio.com',
    storageBucket: 'iot-energy-tracking-app.appspot.com',
    iosClientId: '608917748421-gccvgmmhnsja2k45p27j9ufnub2mlh5r.apps.googleusercontent.com',
    iosBundleId: 'com.example.energyTracker.RunnerTests',
  );
}
