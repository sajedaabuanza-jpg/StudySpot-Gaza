import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web; // قمنا بتغيير الخطأ ليعيد إعدادات الويب فوراً!
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

  // 1. أضيفي إعدادات الويب هنا (انسخي الرموز من موقع الفايربيز للويب)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDAfmi_-AZi4T0qltnlM8p_gwUUo2vcnhw',
    appId: '1:353988480054:web:d4bf5ab6d884bed52a5c97',
    messagingSenderId: '353988480054',
    projectId: 'nearestworkspace',
    storageBucket: 'nearestworkspace.firebasestorage.app',
    authDomain: 'nearestworkspace.firebaseapp.com',
    measurementId: 'G-EPRRJ31VWD',
  );

  // 2. إعدادات الأندرويد الحالية السليمة (اتركيها كما هي)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAogj0yd5S4ZsK1-ijaN9JRH1iaWph6qT8',
    appId: '1:353988480054:android:ee749b732dd97e122a5c97',
    messagingSenderId: '353988480054',
    projectId: 'nearestworkspace',
    storageBucket: 'nearestworkspace.firebasestorage.app',
  );
}