import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - this config is for Android only.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAogj0yd5S4ZsK1-ijaN9JRH1iaWph6qT8',
    appId: '1:353988480054:android:ee749b732dd97e122a5c97',
    messagingSenderId: '353988480054',
    projectId: 'nearestworkspace',
    storageBucket: 'nearestworkspace.firebasestorage.app',
  );
}