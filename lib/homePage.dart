import 'package:flutter/material.dart';
import 'package:nearest_work_space/button/button.dart';
import 'package:nearest_work_space/city.dart';
import 'package:nearest_work_space/googleLogin/googleLogin.dart';

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
                image: AssetImage('images/Welcome.png'),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => city()));
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
}