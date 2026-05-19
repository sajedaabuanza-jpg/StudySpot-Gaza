import 'package:flutter/material.dart';
import 'package:nearest_work_space/alwesta/alwesta.dart';
import 'package:nearest_work_space/button/button.dart';
import 'package:nearest_work_space/khanuonis/khanyonis.dart';
import 'package:url_launcher/url_launcher.dart'; // لا تنسي استيراد الحزمة

import 'gaza/gaza.dart';

Future<void> openMap(double latitude, double longitude) async {
  // رابط مباشر يفتح الإحداثيات في أي مكان
  final String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  final Uri url = Uri.parse(googleUrl);

  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // محاولة بديلة في حال فشل المتصفح في التحقق من canLaunchUrl
      await launchUrl(url);
    }
  } catch (e) {
    debugPrint('Error opening map: $e');
  }
}


class city extends StatelessWidget {
  const city({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // جعلنا الـ AppBar بدون ظل ليتناسق مع التصميم
      appBar: AppBar(
        backgroundColor: const Color(0xFF386A1B),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // خلفية الشاشة
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/city.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // الأزرار والأيقونة
          Positioned.fill( // استخدمنا fill ليأخذ كل المساحة المتاحة
            bottom: 120,    // نتحكم في البعد عن الأسفل من هنا
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // يبدأ الترتيب من الأسفل
              children: [
                button(
                    color: Colors.white,
                    text: 'غزة',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const gaza()));
                    },
                    textColor: const Color(0xFF386A1B)),
                const SizedBox(height: 15),
                button(
                    color: Colors.white,
                    text: 'الوسطى',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const alwesta()));
                    },
                    textColor: const Color(0xFF386A1B)),
                const SizedBox(height: 15),
                button(
                    color: Colors.white,
                    text: 'خانيونس',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const khanyonis()));
                    },
                    textColor: const Color(0xFF386A1B)),

                const SizedBox(height: 40), // مسافة بين آخر زر والأيقونة

                // أيقونة الخريطة مع نص توضيحي
                InkWell(
                  onTap: () => openMap(31.5017, 34.4668),
                  child: Column(
                    children: const [
                      Icon(Icons.location_on, color: Color(0xFF386A1B), size: 45),
                      Text(
                        "عرض الخريطة",
                        style: TextStyle(
                          color: Color(0xFF386A1B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}