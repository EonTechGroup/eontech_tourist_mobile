// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions not configured for Linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBNh0LdBUZJTeSeiKWp9XqOyrQreKk0l5o',
    appId: '1:70293007713:web:b50fd12a6afc8f2cec6920',
    messagingSenderId: '70293007713',
    projectId: 'eontech-super',
    authDomain: 'eontech-super.firebaseapp.com',
    storageBucket: 'eontech-super.firebasestorage.app',
    measurementId: 'G-QYK7JHTLEK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrDYmeke846Kbs4D3m5oV5HrWY0fhNuTU',
    appId: '1:70293007713:android:894e847508fb6766ec6920',
    messagingSenderId: '70293007713',
    projectId: 'eontech-super',
    storageBucket: 'eontech-super.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQBqdFHP2HKKjWsY8RZlX3BBKRXTL2_Ho',
    appId: '1:70293007713:ios:9f131d7c1a94311cec6920',
    messagingSenderId: '70293007713',
    projectId: 'eontech-super',
    storageBucket: 'eontech-super.firebasestorage.app',
    iosClientId: '70293007713-ckv0oek2seta6t6v9jli8g7fjf3slad7.apps.googleusercontent.com',
    iosBundleId: 'com.example.eontechTouristMobile',
  );

  static const FirebaseOptions macos = ios;

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBNh0LdBUZJTeSeiKWp9XqOyrQreKk0l5o',
    appId: '1:70293007713:web:67d040b4eea9d8c9ec6920',
    messagingSenderId: '70293007713',
    projectId: 'eontech-super',
    authDomain: 'eontech-super.firebaseapp.com',
    storageBucket: 'eontech-super.firebasestorage.app',
    measurementId: 'G-3J3FS8645M',
  );
}