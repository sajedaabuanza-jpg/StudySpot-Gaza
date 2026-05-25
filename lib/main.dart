import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


// استيراد الصفحات الخاصة بكِ - تأكدي من صحة المسارات
import 'city.dart';
import 'googleLogin/googleLogin.dart';
import 'homePage.dart';
import 'favorite/favorite.dart';


void main() async {
  // 1. التأكد من تهيئة أدوات فلاتر
  WidgetsFlutterBinding.ensureInitialized();

  // 2. تهيئة فايربيز بالقيم اليدوية لحل مشكلة الـ PlatformException
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAogj0yd5S4ZsK1-ijaN9JRH1iaWph6qT8",
      appId: "1:353988480054:android:e669cb6fdfe57abd2a5c97",
      messagingSenderId: "353988480054",
      projectId: "nearestworkspace",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nearest Work Space',
      // الـ StreamBuilder هو الذي يحدد الشاشة بناءً على حالة المستخدم
      routes: {
        '/favorite': (context) => const favorite(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // حالة التحميل (تظهر للحظات عند فتح التطبيق)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Color(0xFF386A1B))),
            );
          }

          // إذا كان المستخدم مسجل دخوله مسبقاً، اذهبي لصفحة المدن مباشرة
          if (snapshot.hasData) {
            return  city();
          }

          // إذا لم يكن مسجلاً، اذهبي لشاشة تسجيل الدخول (googleLogin)
          // تأكدي أن googleLogin هي الشاشة التي تحتوي على زر "المتابعة باستخدام Google"
          return  homePage();
        },
      ),
    );
  }
}