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
    apiKey: 'AIzaSyBSJ7DobaZWugvIiCJwJ_jvIrryLINqKbI',
    appId: '1:259392011191:web:320d7cb21903162e434632',
    messagingSenderId: '259392011191',
    projectId: 'melodic-metrics-383421',
    authDomain: 'melodic-metrics-383421.firebaseapp.com',
    storageBucket: 'melodic-metrics-383421.appspot.com',
    measurementId: 'G-W5RF9L8YGY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSJ7DobaZWugvIiCJwJ_jvIrryLINqKbI',
    appId: '1:259392011191:android:b4b60d4441383fc7434632',
    messagingSenderId: '259392011191',
    projectId: 'melodic-metrics-383421',
    storageBucket: 'melodic-metrics-383421.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxr8UUidoiD_zyqY1qqSuR7MYPuue_QCA',
    appId: '1:259392011191:ios:1a1ff3132dd8468d434632',
    messagingSenderId: '259392011191',
    projectId: 'melodic-metrics-383421',
    storageBucket: 'melodic-metrics-383421.appspot.com',
    androidClientId: '259392011191-ra8tgcgglte7t2ok8gcqo0jvdn7c7aj9.apps.googleusercontent.com',
    iosClientId: '259392011191-dldqgo8cc6r0mof1rnm5d4hvq9ermo86.apps.googleusercontent.com',
    iosBundleId: 'theripist.com.mender',
  );
}
