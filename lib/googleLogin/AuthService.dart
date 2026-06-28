// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

// class AuthService {
//   // نقوم بإنشاء المتغيرات بدون تهيئة فورية لتفادي كراش الويب عند الاستدعاء
//   late final GoogleSignIn _googleSignIn;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   AuthService() {
//     // نهيئ مكتبة جوجل فقط إذا كنا على الموبايل الفعلي لتفادي الـ Assertion error على الويب
//     if (!kIsWeb) {
//       _googleSignIn = GoogleSignIn();
//     }
//   }

//   // --- دالة تسجيل الدخول بجوجل (المحدثة للتخطي الفوري على المتصفح) ---
//   Future<User?> loginWithGoogle() async {
//     try {
//       // 🌐 إذا كنا نشغل على الويب (Edge) لغرض التجربة كـ Emulator:
//       if (kIsWeb) {
//         print("التطبيق يعمل على Edge كـ Emulator. سيتم التوجيه فوراً لتخطي الحواجز!");

//         // نعيد كائن مستخدم وهمي تماماً لتخطي أي StreamBuilder بدون طلب الفايربيز
//         return _auth.currentUser;
//       }

//       // 📱 إذا كان التطبيق يعمل على الهاتف الفعلي (الأندرويد الحقيقي)
//       else {
//         await _googleSignIn.signOut();

//         final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//         if (googleUser == null) return null;

//         final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );

//         final UserCredential userCredential = await _auth.signInWithCredential(credential);
//         return userCredential.user;
//       }
//     } catch (error) {
//       print("خطأ في الدخول: $error");
//       return null;
//     }
//   }

//   // --- دالة تبديل الحساب ---
//   Future<void> switchAccount() async {
//     try {
//       if (!kIsWeb) {
//         await _googleSignIn.disconnect();
//         await _googleSignIn.signOut();
//       }
//       await _auth.signOut();
//       await loginWithGoogle();
//     } catch (error) {
//       print("خطأ أثناء تبديل الحساب: $error");
//     }
//   }

//   // --- دالة تسجيل الخروج ---
//   Future<void> signOut() async {
//     try {
//       if (!kIsWeb) {
//         await _googleSignIn.signOut();
//       }
//       await _auth.signOut();
//       print("تم تسجيل الخروج بنجاح");
//     } catch (e) {
//       print("خطأ في تسجيل الخروج: $e");
//     }
//   }
// }






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


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // نقوم بإنشاء المتغيرات بدون تهيئة فورية لتفادي كراش الويب عند الاستدعاء
  late final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthService() {
    // نهيئ مكتبة جوجل فقط إذا كنا على الموبايل الفعلي لتفادي الـ Assertion error على الويب
    if (!kIsWeb) {
      _googleSignIn = GoogleSignIn();
    }
  }

  // --- دالة تسجيل الدخول بجوجل (المحدثة للتخطي الفوري على المتصفح) ---
  Future<User?> loginWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        final userCredential = await _auth.signInWithPopup(provider);
        await _syncUserProfile(userCredential.user);
        return userCredential.user;
      }

      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      await _syncUserProfile(userCredential.user);
      return userCredential.user;
    } catch (error) {
      debugPrint("خطأ في الدخول: $error");
      return null;
    }
  }

  Future<void> _syncUserProfile(User? user) async {
    if (user == null) return;

    final userRef = _firestore.collection('users').doc(user.uid);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final providerIds = user.providerData
          .map((provider) => provider.providerId)
          .toList();
      final data = <String, dynamic>{
        'uid': user.uid,
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
        'providerIds': providerIds,
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

      if (snapshot.exists) {
        transaction.set(userRef, data, SetOptions(merge: true));
      } else {
        transaction.set(userRef, {
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    });
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
      debugPrint("خطأ أثناء تبديل الحساب: $error");
    }
  }

  // --- دالة تسجيل الخروج ---
  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
      debugPrint("تم تسجيل الخروج بنجاح");
    } catch (e) {
      debugPrint("خطأ في تسجيل الخروج: $e");
    }
  }
}