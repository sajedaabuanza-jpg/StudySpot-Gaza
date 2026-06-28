import 'package:flutter/material.dart';
import 'package:studyspot/button/button.dart';

// استيراد ملفات مناطق الوسطى بناءً على المجلد الخاص بك
import 'package:studyspot/al-westa/al-bureij.dart';
import 'package:studyspot/al-westa/al-maghazi.dart';
import 'package:studyspot/al-westa/al-zawayda.dart';
import 'package:studyspot/al-westa/deir al-balah.dart';
import 'package:studyspot/al-westa/nuseirat.dart';
import 'package:studyspot/favorite/favorite.dart';

class AlWesta extends StatelessWidget {
  const AlWesta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF386A1B),
        iconTheme: const IconThemeData(color: Colors.white), // تلوين زر الرجوع بالأبيض
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Color(0xFF386A1B)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const favorite()));
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ch_area.jpg'), // نفس مسار الخلفية المستخدم في شاشة غزة
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 180), // نفس المسافة لتناسق التصميم
          child: SingleChildScrollView( // سكرول لحماية الواجهة من الـ Overflow
            child: Column(
              children: [
                // 1. زر دير البلح
                button(
                  color: Colors.white,
                  text: 'دير البلح',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DeirAlBalah()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 15),

                // 2. زر النصيرات
                button(
                  color: Colors.white,
                  text: 'النصيرات',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Nuseirat()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 15),

                // 3. زر البريج
                button(
                  color: Colors.white,
                  text: 'البريج',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AlBureij()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 15),

                // 4. زر المغازي
                button(
                  color: Colors.white,
                  text: 'المغازي',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AlMaghazi()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 15),

                // 5. زر الزوايدة
                button(
                  color: Colors.white,
                  text: 'الزوايدة',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AlZawayda()));
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