import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
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

  // إعدادات الويب المحدثة والمتوافقة مع كود الـ Pull الجديد
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyArGe4b8b3jPU59_VC9vGgeeTbwevwQUhk',
    appId: '1:644719264139:web:fd502ca45a8fbfab70ef8e',
    messagingSenderId: '644719264139',
    projectId: 'studyspot-gaza',
    authDomain: 'studyspot-gaza.firebaseapp.com',
    storageBucket: 'studyspot-gaza.firebasestorage.app',
    measurementId: 'G-68Q9HWCST1',
  );

  // إعدادات الأندرويد المحدثة والمتوافقة مع كود الـ Pull الجديد
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFjmELB0z48hIh9ndM63a9VzSJ51ANoB8',
    appId: '1:644719264139:android:b72ef29cea8f6e0d70ef8e',
    messagingSenderId: '644719264139',
    projectId: 'studyspot-gaza',
    storageBucket: 'studyspot-gaza.firebasestorage.app',
  );
}