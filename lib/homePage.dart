import 'package:flutter/material.dart';
import 'package:studyspot/button/button.dart';
import 'package:studyspot/city.dart'; // استيراد شاشة المدن للتنقل المباشر
import 'package:studyspot/googleLogin/AuthService.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // مهم جداً للتعرف على الويب

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 1. صورة الخلفية
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Welcome.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // 2. المحتوى البرمجي المنظم
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.44),

                    // العنوان الرئيسي
                    const Text(
                      "اعثر على مكانك المثالي",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 8),

                    // النص الوصفي
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "اكتشف أقرب أماكن الدراسة إليك _ مع معلومات عن الكهرباء والإنترنت والأسعار",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6A994E),
                          height: 1.4,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.16),

                    // قسم الأزرار الذكي (يدعم محاكاة الويب والتشغيل الحقيقي للهاتف)
                    Column(
                      children: [
                        // زر تسجيل الدخول بـ Google
                        button(
                          color: const Color(0xFF386A1B),
                          text: 'المتابعة باستخدام Google',
                          onPressed: () async {
                            // 🌐 إذا كنا على المتصفح: تصرف كـ Emulator وانتقل فوراً
                            if (kIsWeb) {
                              print("تخطي ذكي: الانتقال المباشر لشاشة المدن على Edge");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const city()),
                              );
                            }
                            // 📱 إذا كنا على الهاتف: شغل نظام الفايربيز الحقيقي
                            else {
                              final userAccount = await AuthService().loginWithGoogle();
                              if (userAccount != null) {
                                print("تم تسجيل الدخول بنجاح للمستخدم: ${userAccount.displayName}");
                              }
                            }
                          },
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: 15),

                        // زر دخول سريع للتجربة (المثالي للمتصفح بدون قيود)
                        button(
                          color: Colors.white,
                          text: 'دخول سريع للتجربة',
                          onPressed: () {
                            // ينقل مباشرة لشاشة المدن في الحالتين لتسهيل المعاينة والتجربة السريعة
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const city()),
                            );
                          },
                          textColor: const Color(0xFF386A1B),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/*import 'package:flutter/material.dart';
import 'package:studyspot/button/button.dart';
import 'package:studyspot/googleLogin/AuthService.dart'; // استيراد ملف الخدمة مباشرة هنا

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 1. صورة الخلفية
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Welcome.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // 2. المحتوى البرمجي المنظم
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.44),

                    // العنوان الرئيسي
                    const Text(
                      "اعثر على مكانك المثالي",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 8),

                    // النص الوصفي
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "اكتشف أقرب أماكن الدراسة إليك _ مع معلومات عن الكهرباء والإنترنت والأسعار",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6A994E),
                          height: 1.4,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.16),

                    // قسم الأزرار المعدل بالمنطق الجديد
                    Column(
                      children: [
                        // زر تسجيل الدخول الفعلي بـ Google
                        button(
                          color: const Color(0xFF386A1B),
                          text: 'المتابعة باستخدام Google',
                          onPressed: () async {
                            // نستدعي دالة الدخول مباشرة لفتح قائمة الحسابات
                            final userAccount = await AuthService().loginWithGoogle();
                            if (userAccount != null) {
                              print("تم تسجيل الدخول بنجاح للمستخدم: ${userAccount.displayName}");
                              // الـ StreamBuilder في الـ main.dart سينتبه فوراً وينقلك لصفحة الـ city تلقائياً
                            }
                          },
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: 15),

                        // زر مخصص للتجربة (لو كنتِ تريدين دخول زائر بدون فايربيز مستقبلاً)
                        // قمنا بتعطيله مؤقتاً أو تركه كإجراء شكلي لتفادي الـ Crash الصامت للـ null user
                        button(
                          color: Colors.white,
                          text: 'دخول سريع للتجربة',
                          onPressed: () async {
                            // الأفضل هنا أيضاً استدعاء loginWithGoogle لضمان وجود حساب للمستخدم قبل دخول صفحة المدن
                            await AuthService().loginWithGoogle();
                          },
                          textColor: const Color(0xFF386A1B),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:studyspot/button/button.dart';
import 'package:studyspot/city.dart';
import 'package:studyspot/googleLogin/googleLogin.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام MediaQuery لجعل التصميم مرناً على مختلف أحجام الشاشات
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // 1. صورة الخلفية (التي تحتوي على الشعار والأيقونات الأربعة)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Welcome.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // 2. المحتوى البرمجي المنظم
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    // مسافة علوية لترك مجال للشعار العلوي في الصورة
                    SizedBox(height: screenHeight * 0.44),

                    // العنوان الرئيسي
                    const Text(
                      "اعثر على مكانك المثالي",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24, // تصغير بسيط ليناسب المساحة البيضاء
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                        fontFamily: 'Cairo', // تأكدي من تعريف الخط في pubspec
                      ),
                    ),
                    const SizedBox(height: 8),

                    // النص الوصفي
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "اكتشف أقرب أماكن الدراسة إليك _ مع معلومات عن الكهرباء والإنترنت والأسعار",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6A994E),
                          height: 1.4,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),

                    // مسافة مرنة تترك مجالاً للأيقونات الأربعة الموجودة في الخلفية
                    // هذه القيمة هي "مفتاح" التنسيق لكي لا تغطي الأزرار الأيقونات
                    SizedBox(height: screenHeight * 0.16),

                    // قسم الأزرار
                    Column(
                      children: [
                        button(
                          color: const Color(0xFF386A1B),
                          text: 'تسجيل الدخول',
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const googleLogin()));
                          },
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: 15),
                        button(
                          color: Colors.white,
                          text: 'للتجربة"سبق ان سجل"',
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const city()));
                          },
                          textColor: const Color(0xFF386A1B),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30), // مسافة أمان سفلية
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/