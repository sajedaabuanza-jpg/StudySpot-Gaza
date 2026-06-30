import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  // نقوم بإنشاء المتغيرات بدون تهيئة فورية لتفادي كراش الويب عند الاستدعاء
  late final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService() {
    // نهيئ مكتبة جوجل فقط إذا كنا على الموبايل الفعلي لتفادي الـ Assertion error على الويب
    if (!kIsWeb) {
      _googleSignIn = GoogleSignIn();
    }
  }

  // --- دالة تسجيل الدخول بجوجل (المحدثة للتخطي الفوري على المتصفح) ---
  Future<User?> loginWithGoogle() async {
    try {
      // 🌐 إذا كنا نشغل على الويب (Edge) لغرض التجربة كـ Emulator:
      if (kIsWeb) {
        print("التطبيق يعمل على Edge كـ Emulator. سيتم التوجيه فوراً لتخطي الحواجز!");

        // نعيد كائن مستخدم وهمي تماماً لتخطي أي StreamBuilder بدون طلب الفايربيز
        return _auth.currentUser;
      }

      // 📱 إذا كان التطبيق يعمل على الهاتف الفعلي (الأندرويد الحقيقي)
      else {
        await _googleSignIn.signOut();

        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (error) {
      print("خطأ في الدخول: $error");
      return null;
    }
  }

  // --- دالة تبديل الحساب ---
  Future<void> switchAccount() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
      await loginWithGoogle();
    } catch (error) {
      print("خطأ أثناء تبديل الحساب: $error");
    }
  }

  // --- دالة تسجيل الخروج ---
  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
      print("تم تسجيل الخروج بنجاح");
    } catch (e) {
      print("خطأ في تسجيل الخروج: $e");
    }
  }
}
/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- دالة تسجيل الدخول بجوجل ---
  Future<User?> loginWithGoogle() async {
    try {
      // تصفير أي جلسة معلقة لجوجل لإجبار النظام على فتح القائمة دائماً
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (error) {
      print("خطأ في الدخول: $error");
      return null;
    }
  }

  // --- دالة تبديل الحساب (تُظهر القائمة حتماً) ---
  Future<void> switchAccount() async {
    try {
      // فصل الحساب الحالي تماماً ومسحه من الكاش الداخلي للتطبيق
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await _auth.signOut();

      print("تم فصل الحساب بنجاح، جاري فتح قائمة الحسابات من جديد...");

      // استدعاء دالة الدخول مجدداً لتظهر قائمة الحسابات ليختار منها المستخدم
      await loginWithGoogle();

    } catch (error) {
      print("خطأ أثناء تبديل الحساب: $error");
    }
  }

  // --- دالة تسجيل الخروج والعودة لصفحة البداية تلقائياً ---
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut(); // هنا يتأثر الـ Stream ويقوم بعمل التوجيه لـ homePage فوراً
      print("تم تسجيل الخروج بنجاح");
    } catch (e) {
      print("خطأ في تسجيل الخروج: $e");
    }
  }
}

  // --- دالة تسجيل الخروج ---
 /* Future<void> signOut() async {
    try {
      // نكتفي بـ signOut لإيقاف الجلسة والعودة لصفحة اللوجن
      await _googleSignIn.signOut();
      await _auth.signOut();
      print("تم تسجيل الخروج والعودة لصفحة البداية");
    } catch (e) {
      print("خطأ في تسجيل الخروج: $e");
    }
  }

  // دالة تسجيل الدخول (تأكدي أنها موجودة لديكي)
  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (error) {
      print("خطأ في الدخول: $error");
      return null;
    }
  }*/
*/