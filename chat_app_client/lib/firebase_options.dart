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
        return windows;
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
    apiKey: 'AIzaSyCNoQvSIExTHuFVjKin5dJNbQWo6KRKHRw',
    appId: '1:1088294796319:android:03dc9f6876d795ecf7692a',
    messagingSenderId: '1088294796319',
    projectId: 'chat-ws-89088',
    storageBucket: 'chat-ws-89088.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCvGQGFcwJw2tA6gyI4JKkgF0YiYK2O9xc',
    appId: '1:1088294796319:ios:6aad5d363e9c8f07f7692a',
    messagingSenderId: '1088294796319',
    projectId: 'chat-ws-89088',
    storageBucket: 'chat-ws-89088.firebasestorage.app',
    iosBundleId: 'com.example.chatAppClient',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAHyk7rFYXQUEKV5bUVkZfJYrOe7lvfSBc',
    appId: '1:1088294796319:web:95f1e8498797390cf7692a',
    messagingSenderId: '1088294796319',
    projectId: 'chat-ws-89088',
    authDomain: 'chat-ws-89088.firebaseapp.com',
    storageBucket: 'chat-ws-89088.firebasestorage.app',
    measurementId: 'G-M8GMSX4H47',
  );

}