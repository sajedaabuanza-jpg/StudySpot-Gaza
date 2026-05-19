import 'package:flutter/material.dart';

class button extends StatelessWidget {

  final String text;      // النص المتغير
  final Color color;      // لون الزر المتغير
  final VoidCallback onPressed; // الوظيفة عند الضغط
  final Color textColor ;
  button({super.key,required this.color,required this.text,required this.onPressed , required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 250,
      child: ElevatedButton(onPressed: onPressed,style: ElevatedButton.styleFrom(
        backgroundColor: color,
          minimumSize: const Size(300, 55), // الحجم الثابت من تصميمك
            shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
      )
      ),
        child: Center(child: Text(text , style: TextStyle(color:textColor ,fontSize: 18,fontWeight: FontWeight.bold))) ,
      ),
    );
  }
}
