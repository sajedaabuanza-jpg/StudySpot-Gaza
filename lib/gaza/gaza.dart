import 'package:flutter/material.dart';
import 'package:nearest_work_space/button/button.dart';
import 'package:nearest_work_space/gaza/al_nusser.dart';
import 'package:nearest_work_space/gaza/alremal.dart';
import 'package:nearest_work_space/gaza/shamalGaza.dart';
import 'package:nearest_work_space/gaza/talallhawa.dart';
import 'altofah.dart';

class gaza extends StatelessWidget {
  const gaza({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF386A1B),
        iconTheme: const IconThemeData(color: Colors.white), // تلوين زر الرجوع بالأبيض
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
          padding: const EdgeInsets.only(top: 180), // تقليل المسافة قليلاً لتناسب زيادة عدد الأزرار دون حدوث Overflow
          child: SingleChildScrollView( // إضافة سكرول لحماية الشاشات الصغيرة من مشاكل الـ Overflow
            child: Column(
              children: [
                // 1. زر النصر
                button(
                  color: Colors.white,
                  text: 'النصر',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const al_nusser()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 15),

                // 2. زر التفاح
                button(
                  color: Colors.white,
                  text: 'التفاح',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const altofah()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 15),

                // 3. زر الرمال
                button(
                  color: Colors.white,
                  text: 'الرمال',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const alremal()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 15),

                // 4. زر تل الهوا
                button(
                  color: Colors.white,
                  text: 'تل الهوا',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const talallhawa()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 15),

                // 5. زر شمال غزة
                button(
                  color: Colors.white,
                  text: 'شمال غزة',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const shamalGaza()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 20), // مسافة أمان بالأسفل
              ],
            ),
          ),
        ),
      ),
    );
  }
}