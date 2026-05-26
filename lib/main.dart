import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:nearest_work_space/homePage.dart';

// استيراد الصفحات الخاصة بكِ
import 'city.dart';
import 'googleLogin/googleLogin.dart';

void main() async {
  // التأكد من تهيئة الإضافات
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة فايربيز (استخدمي خياراتك الخاصة هنا)
=======
import 'package:firebase_core/firebase_core.dart'; // إضافة الاستيراد
import 'package:nearest_work_space/homePage.dart';
import 'firebase_options.dart'; // إضافة استدعاء ملف الخيارات

void main() async {
  // تأمين تهيئة الحزم قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الفايربيس
>>>>>>> 7a76ac2e8940acf768aa710c179f69c9996da830
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
<<<<<<< HEAD
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
=======
      home: homePage(),
>>>>>>> 7a76ac2e8940acf768aa710c179f69c9996da830
    );
  }
}