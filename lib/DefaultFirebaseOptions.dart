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

  // إعدادات الويب المحدثة للمشروع الجديد nearestWorkspace
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyArGe4b8b3jPU59_VC9vGgeeTbwevwQUhk',
    appId: '1:644719264139:web:fd502ca45a8fbfab70ef8e',
    messagingSenderId: '644719264139',
    projectId: 'nearestWorkspace', // تغيير اسم المشروع هنا
    authDomain: 'nearestWorkspace.firebaseapp.com', // تحديث النطاق
    storageBucket: 'nearestWorkspace.firebasestorage.app', // تحديث المخزن
    measurementId: 'G-68Q9HWCST1',
  );

  // إعدادات الأندرويد المحدثة للمشروع الجديد nearestWorkspace
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFjmELB0z48hIh9ndM63a9VzSJ51ANoB8',
    appId: '1:644719264139:android:b72ef29cea8f6e0d70ef8e',
    messagingSenderId: '644719264139',
    projectId: 'nearestWorkspace', // تغيير اسم المشروع هنا ليطابق قاعدة البيانات الجديدة
    storageBucket: 'nearestWorkspace.firebasestorage.app', // تحديث المخزن للأندرويد
  );
}