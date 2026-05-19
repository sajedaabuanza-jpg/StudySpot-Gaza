import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:nearest_work_space/button/button.dart';
import 'package:nearest_work_space/city.dart';
import 'package:nearest_work_space/googleLogin/googleLogin.dart'; //  ضروري عشان تأثير الـ Blur ضبابية الصورة

class homePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// استخدمنا Stack لأننا نريد وضع العناصر فوق بعضها (خلفية، ثم طبقة ضبابية، ثم نصوص)
      body: Stack(
        children: [
      // 1. الطبقة الأولى: صورة الخلفية
      // الـ Container هنا يأخذ كامل مساحة الشاشة
          Container(
            decoration:const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Group 11 (1).png'), // تأكدي من الاسم في فيجما
            fit: BoxFit.fill,

            )
           )
          )
          ,

          Positioned(
            bottom: 110, // المسافة من أسفل الشاشة
            left: 0,
            right: 0,

            child: Column(
              children: [
                button(color: const Color(0xFF386A1B), text:'Login' , onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const googleLogin()));}, textColor: Colors.white),
                const SizedBox(height: 15), // مسافة بسيطة بين الزرين
                button(color: Colors.white, text:'already loged' , onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const city()));}, textColor: const Color(0xFF386A1B))
              ],
            ),
          )

        ],
      ),
    );
  }
}
