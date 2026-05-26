import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nearest_work_space/homePage.dart';

// استيراد الصفحات الخاصة بكِ
import 'city.dart';
import 'googleLogin/googleLogin.dart';

void main() async {
  // التأكد من تهيئة الإضافات
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة فايربيز (استخدمي خياراتك الخاصة هنا)
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

      // الـ StreamBuilder هو "المراقب" الذي يغير الواجهة تلقائياً
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          // 1. حالة التحميل عند فتح التطبيق لأول مرة
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Color(0xFF386A1B))),
            );
          }

          // 2. إذا وجد مستخدم (حالة تسجيل دخول ناجحة أو تبديل حساب)
          if (snapshot.hasData) {
            // سيفتح صفحة المدن، وبما أنكِ تستخدمين FirebaseAuth.instance.currentUser
            // في صفحة city، ستتحدث البيانات (الاسم والصورة) تلقائياً للحساب الجديد.
            return city();
          }

          // 3. إذا لم يجد مستخدم (حالة تسجيل خروج)
          // سيعيدك التطبيق فوراً لصفحة اللوجن التي تحتوي على زر "Google Login"
          return  homePage();
        },
      ),
    );
  }
}