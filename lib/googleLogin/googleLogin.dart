import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // تركنا الـ Constructor فارغاً ليقرأ تلقائياً من الإعدادات المحلية للأندرويد
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- دالة تسجيل الدخول بجوجل ---
  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // المستخدم ألغى العملية

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

  // --- دالة تبديل الحساب ---
  Future<void> switchAccount() async {
    try {
      // تسجيل الخروج التام لمسح الكاش وفتح نافذة اختيار الحسابات مجدداً
      await _googleSignIn.signOut();
      await _auth.signOut();

      // طلب تسجيل دخول جديد فوراً
      await loginWithGoogle();
      print("تم التبديل بنجاح");
    } catch (error) {
      print("خطأ في التبديل: $error");
    }
  }

  // --- دالة تسجيل الخروج ---
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      print("تم تسجيل الخروج بنجاح");
    } catch (e) {
      print("خطأ في تسجيل الخروج: $e");
    }
  }
}
/*import 'package:flutter/material.dart';
import '../city.dart';
import 'AuthService.dart';

class googleLogin extends StatelessWidget {
  const googleLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(backgroundColor:const Color(0xFF386A1B) ),
      // أزلنا اللون من الـ Scaffold لأننا سنضع صورة
      body: Stack(
        children: [
          // 1. طبقة الخلفية (الصورة)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(

                image: AssetImage('assets/images/loginBacGround.png'),
                fit: BoxFit.cover, // لجعلها تغطي الشاشة بالكامل
              ),
            ),
          ),

          // 2. طبقة تعتيم خفيفة (اختياري) لتوضيح المحتوى فوق الصورة
          Container(
            color: Colors.white.withOpacity(0.6), // يمكنكِ التحكم في درجة الشفافية هنا
          ),

          // 3. طبقة المحتوى الأصلية (الكود الخاص بكِ)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // لجعل المحتوى يتوسط الخلفية
                children: [
                  Container(
                    padding: const EdgeInsets.all(15), // إضافة padding حول الأيقونة
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.maps_home_work_outlined,
                      size: 80,
                      color: Color(0xFF386A1B),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'مرحباً بك',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ابحث عن مساحة العمل المشتركة الأقرب إليك وابدأ إنجاز أعمالك بكل سهولة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87, // جعلنا اللون أغمق قليلاً ليظهر فوق الخلفية
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () async {
                      final userAccount = await AuthService().loginWithGoogle();
                      if (userAccount != null) {
                        print("أهلاً بك يا: ${userAccount.displayName}");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>  const city()),
                        );
                      } else {
                        print("فشلت عملية تسجيل الدخول أو تم إلغاؤها");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 4, // زيادة الظل قليلاً ليعطي عمقاً فوق الصورة
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF386A1B),
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            'G',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'المتابعة باستخدام حساب Google',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


 */