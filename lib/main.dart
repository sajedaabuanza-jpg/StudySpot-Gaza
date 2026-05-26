import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // إضافة الاستيراد
import 'package:nearest_work_space/homePage.dart';
import 'firebase_options.dart'; // إضافة استدعاء ملف الخيارات

void main() async {
  // تأمين تهيئة الحزم قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الفايربيس
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage(),
    );
  }
}