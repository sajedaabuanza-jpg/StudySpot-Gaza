import 'package:firebase_auth/firebase_auth.dart';
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
