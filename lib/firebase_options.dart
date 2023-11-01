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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnta9an-MGC_-UQ21g2sa6Pq7YhpzaBL4',
    appId: '1:63417815638:android:c6a6ea773f45ad02e861f7',
    messagingSenderId: '63417815638',
    projectId: 'team-it-e6c00',
    databaseURL: 'https://team-it-e6c00-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'team-it-e6c00.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbBSHZ13_N47FzvZMOzbBKj77LsQYgO3A',
    appId: '1:63417815638:ios:8a35c375dae3d6a7e861f7',
    messagingSenderId: '63417815638',
    projectId: 'team-it-e6c00',
    databaseURL: 'https://team-it-e6c00-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'team-it-e6c00.appspot.com',
    iosBundleId: 'com.example.untitled2',
  );
}
