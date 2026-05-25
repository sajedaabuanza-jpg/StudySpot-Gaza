import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // تأكدي أن الأسماء هنا تبدأ بـ (_)
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // دالة تسجيل الدخول (موجودة عندك)
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
  }

  // دالة تسجيل الخروج العادي
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // دالة تبديل الحساب (هنا التعديل لإزالة الخطأ الأحمر)
  Future<void> switchAccount() async {
    try {
      // تأكدي من كتابة _googleSignIn بالضبط كما عرفتيها فوق
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (error) {
      print("خطأ في التبديل: $error");
      await signOut(); // في حال الفشل نكتفي بالخروج العادي
    }
  }
}