import 'package:flutter/material.dart';
import 'package:nearest_work_space/button/button.dart';

class khanyonis extends StatelessWidget {
  const khanyonis({super.key});

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
              button(color: Colors.white, text: 'البلد', onPressed: (){}, textColor: const Color(0xFF386A1B)),
              const SizedBox(height: 15), //
              button(color: Colors.white, text: 'المواصي', onPressed: (){}, textColor: const Color(0xFF386A1B)),
              const SizedBox(height: 15), //
              button(color: Colors.white, text: 'مدينة حمد والقرارة', onPressed: (){}, textColor: const Color(0xFF386A1B)),

            ],
          ),
        ),
      ),

    );
  }
}

