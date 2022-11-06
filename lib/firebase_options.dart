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
    apiKey: 'AIzaSyAdhyVoZlDWosJsD8O3hZTngY427qA4dEg',
    appId: '1:366342800582:web:031567e3ed97f8cbaf83c7',
    messagingSenderId: '366342800582',
    projectId: 'remindify-bd881',
    authDomain: 'remindify-bd881.firebaseapp.com',
    storageBucket: 'remindify-bd881.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyr1gxPj2VNV_94n8FtpIKQN58fAU9aSI',
    appId: '1:366342800582:android:c0995a5dac8865fcaf83c7',
    messagingSenderId: '366342800582',
    projectId: 'remindify-bd881',
    storageBucket: 'remindify-bd881.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD7hgr9U744RqrQwGlbo0v9MEmK1tSB6RM',
    appId: '1:366342800582:ios:74670edda3153720af83c7',
    messagingSenderId: '366342800582',
    projectId: 'remindify-bd881',
    storageBucket: 'remindify-bd881.appspot.com',
    iosClientId: '366342800582-k0kp01bjq8q8lu84i3vi22f77enfdr5s.apps.googleusercontent.com',
    iosBundleId: 'com.example.remindify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD7hgr9U744RqrQwGlbo0v9MEmK1tSB6RM',
    appId: '1:366342800582:ios:74670edda3153720af83c7',
    messagingSenderId: '366342800582',
    projectId: 'remindify-bd881',
    storageBucket: 'remindify-bd881.appspot.com',
    iosClientId: '366342800582-k0kp01bjq8q8lu84i3vi22f77enfdr5s.apps.googleusercontent.com',
    iosBundleId: 'com.example.remindify',
  );
}
