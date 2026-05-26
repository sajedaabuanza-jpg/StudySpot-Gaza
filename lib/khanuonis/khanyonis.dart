import 'package:flutter/material.dart';
import 'package:nearest_work_space/button/button.dart';
import 'package:nearest_work_space/khanuonis/al_mawasi.dart'; // استيراد صفحة المواصي القادمة من الفايرستور

class khanyonis extends StatelessWidget {
  const khanyonis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF386A1B),
        iconTheme: const IconThemeData(color: Colors.white), // تلوين زر الرجوع باللون الأبيض
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ch_area.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 220),
          child: Column(
            children: [
              // زر البلد
              button(
                color: Colors.white,
                text: 'البلد',
                onPressed: () {
                  // يمكنك ربطها لاحقاً بنفس طريقة المواصي عند تجهيز صفحتها
                },
                textColor: const Color(0xFF386A1B),
              ),
              const SizedBox(height: 15),

              // زر المواصي (تم ربطه وتفعيله بنجاح مع الفايرستور)
              button(
                color: Colors.white,
                text: 'المواصي',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const al_mawasi()),
                  );
                },
                textColor: const Color(0xFF386A1B),
              ),
              const SizedBox(height: 15),

              // زر مدينة حمد والقرارة
              button(
                color: Colors.white,
                text: 'مدينة حمد والقرارة',
                onPressed: () {
                  // يمكنك ربطها لاحقاً بنفس طريقة المواصي عند تجهيز صفحتها
                },
                textColor: const Color(0xFF386A1B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}