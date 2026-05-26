import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart'; // أضفنا MaterialApp لاستخدام BuildContext

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> switchAccount() async {
    try {
      // 1. فصل الحساب الحالي
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await _auth.signOut();

      // 2. طلب تسجيل دخول جديد فوراً
      // هنا تظهر قائمة الحسابات، وبمجرد الاختيار يتم تسجيل الدخول
      await loginWithGoogle();

      print("تم التبديل بنجاح");
    } catch (error) {
      print("خطأ في التبديل: $error");
    }
  }
  // --- دالة تسجيل الخروج ---
  Future<void> signOut() async {
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
