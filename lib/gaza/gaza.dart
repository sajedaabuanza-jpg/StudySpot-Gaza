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
      appBar: AppBar(backgroundColor: const Color(0xFF386A1B),),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/ch_area.jpg'),fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.only(top: 220),
          child: Column(
            children: [
              button(color: Colors.white, text: 'النصر', onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => al_nusser(),));}, textColor: const Color(0xFF386A1B)),
              const SizedBox(height: 15), //
              button(color: Colors.white, text: 'التفاح', onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => altofah(),));}, textColor: const Color(0xFF386A1B)),
              const SizedBox(height: 15), //
              button(color: Colors.white, text: 'الرمال', onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => alremal(),));}, textColor: const Color(0xFF386A1B)),
              const SizedBox(height: 15), //
              button(color: Colors.white, text: 'تل الهوا', onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => talallhawa(),));}, textColor: const Color(0xFF386A1B)),
              const SizedBox(height: 15), //
              button(color: Colors.white, text: 'شمال غزة', onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => shamalGaza(),));}, textColor: const Color(0xFF386A1B)),
            ],
          ),
        ),
      ),

    );
  }
}

