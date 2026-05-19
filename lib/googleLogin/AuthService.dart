import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // 1. إنشاء كائن للاتصال بجوجل
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 2. دالة تسجيل الدخول (نستخدم Future لأنها تأخذ وقتاً للاتصال بالإنترنت)
  Future<GoogleSignInAccount?> loginWithGoogle() async {
    try {
      // فتح النافذة للمستخدم ليختار حسابه
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      return account; // سترجع لنا بيانات الحساب (الاسم، الايميل، الصورة)
    } catch (error) {
      print("حدث خطأ أثناء تسجيل الدخول: $error");
      return null;
    }
  }
}