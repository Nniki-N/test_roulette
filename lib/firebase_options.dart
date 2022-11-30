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
    apiKey: 'AIzaSyBwPmpF7nvIP5Sqj-qMBBX_JiNbeAokOog',
    appId: '1:957977483003:web:fe764cc8382afb6396425e',
    messagingSenderId: '957977483003',
    projectId: 'test-roulette-e4132',
    authDomain: 'test-roulette-e4132.firebaseapp.com',
    storageBucket: 'test-roulette-e4132.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC7O96d--sxSaMODjGeAhI50-vSavOj3ww',
    appId: '1:957977483003:android:4520d760dc7852a196425e',
    messagingSenderId: '957977483003',
    projectId: 'test-roulette-e4132',
    storageBucket: 'test-roulette-e4132.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-XundkZeq0QunoGXaXCiQF_LkhaUmmns',
    appId: '1:957977483003:ios:c2189f33d2ccc6e996425e',
    messagingSenderId: '957977483003',
    projectId: 'test-roulette-e4132',
    storageBucket: 'test-roulette-e4132.appspot.com',
    iosClientId: '957977483003-gtdn5u4tmka28k8ijjvshq1anfasenb6.apps.googleusercontent.com',
    iosBundleId: 'com.example.testRoulette',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-XundkZeq0QunoGXaXCiQF_LkhaUmmns',
    appId: '1:957977483003:ios:c2189f33d2ccc6e996425e',
    messagingSenderId: '957977483003',
    projectId: 'test-roulette-e4132',
    storageBucket: 'test-roulette-e4132.appspot.com',
    iosClientId: '957977483003-gtdn5u4tmka28k8ijjvshq1anfasenb6.apps.googleusercontent.com',
    iosBundleId: 'com.example.testRoulette',
  );
}