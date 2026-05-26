import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nearest_work_space/alwesta/alwesta.dart';
import 'package:nearest_work_space/button/button.dart';
import 'package:nearest_work_space/khanuonis/khanyonis.dart';
import 'package:url_launcher/url_launcher.dart'; // لا تنسي استيراد الحزمة

import 'gaza/gaza.dart';
import 'googleLogin/AuthService.dart';

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
   city({super.key});
  // 1. جلب بيانات المستخدم الحالي من فايربيز
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xFF386A1B),
        elevation: 0,

      ),

      drawer: Drawer(child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF386A1B)),
            // عرض الاسم من جوجل، وإذا لم يوجد نضع نصاً افتراضياً
            accountName: Text(user?.displayName ?? "مستخدم جديد"),
            // عرض الإيميل من جوجل
            accountEmail: Text(user?.email ?? "لا يوجد إيميل"),
            // عرض الصورة الشخصية من جوجل
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, size: 40, color: Color(0xFF386A1B))
                  : null,
            ),
          ),
          // عناصر القائمة
          ListTile(
            leading: Icon(Icons.home),
            title: Text("تبديل الحساب"),
            onTap: () async {
              // 1. إغلاق القائمة الجانبية (Drawer)
              Navigator.pop(context);

              try {
                // 2. إشعار المستخدم
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("جاري التجهيز لتبديل الحساب...")),
                );

                // 3. استدعاء دالة التبديل من الـ AuthService
                await AuthService().switchAccount();

                // الـ StreamBuilder سيتكفل بإرجاع المستخدم لصفحة تسجيل الدخول تلقائياً
              } catch (e) {
                print("خطأ أثناء تبديل الحساب: $e");
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("الإعدادات"),
            onTap: () {
              // كود الانتقال لصفحة الإعدادات
            },
          ),
          Divider(), // خط فاصل
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("تسجيل الخروج"),
            onTap: () async {
          // 1. إغلاق الـ Drawer أولاً!
          // إذا لم نغلقه، قد يظل مفتوحاً أو يظهر للحظة أثناء الانتقال لصفحة التسجيل
          Navigator.pop(context);

          // 2. تنفيذ عملية تسجيل الخروج
          try {
          await AuthService().signOut();
          // الـ StreamBuilder سيتكفل بالباقي
          } catch (e) {
          // يفضل دائماً وضعها في try-catch لتجنب أي تعليق في الواجهة
          print("خطأ أثناء تسجيل الخروج: $e");
          }
          },
          ),

        ],
      )),
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
            bottom: 190,    // نتحكم في البعد عن الأسفل من هنا
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