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
    apiKey: 'AIzaSyCy2V5RwuGp6fqSyhbzNlROfVwHFTW11js',
    appId: '1:686727571817:web:cf27e972d59504348435f8',
    messagingSenderId: '686727571817',
    projectId: 'smart-volt-b4aaa',
    authDomain: 'smart-volt-b4aaa.firebaseapp.com',
    storageBucket: 'smart-volt-b4aaa.appspot.com',
    measurementId: 'G-L24VHFZJ14',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAg_dUJIwZlfxHTHwnc1x3pxXG0_XHR-kE',
    appId: '1:686727571817:android:cda9999c533f93d48435f8',
    messagingSenderId: '686727571817',
    projectId: 'smart-volt-b4aaa',
    storageBucket: 'smart-volt-b4aaa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCY1twvT4sAZRG4RSRq9p8YDuh7PkxTXgE',
    appId: '1:686727571817:ios:023779746acce0e08435f8',
    messagingSenderId: '686727571817',
    projectId: 'smart-volt-b4aaa',
    storageBucket: 'smart-volt-b4aaa.appspot.com',
    iosBundleId: 'com.smart.volt.smartvolt1',
  );
}