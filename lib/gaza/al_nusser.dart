import 'package:flutter/material.dart';
import 'package:nearest_work_space/card/WorkspaceCard.dart';

class al_nusser extends StatefulWidget {
  const al_nusser({super.key});

  @override
  State<al_nusser> createState() => _al_nusserState();
}

class _al_nusserState extends State<al_nusser> {
  // اي مسافة حيتم اضافتها جديد تضاف هنا باللبست
  final List<Map<String,dynamic>> workspaces = [{'title': 'مساحة1',
    'location': 'النصر_....',
    'imagePath': 'assets/images/Group 10.jpg',
    'rating': 3.0},{
    'title': 'مساحة1',
    'location': 'النصر_....',
    'imagePath': 'assets/images/Group 10.jpg',
    'rating': 3.0
  },{'title': 'مساحة1',
    'location': 'النصر_....',
    'imagePath': 'assets/images/Group 10.jpg',
    'rating': 3.0},{'title': 'مساحة1',
    'location': 'النصر_....',
    'imagePath': 'assets/images/Group 10.jpg',
    'rating': 3.0}];
  @override
  Widget build(BuildContext context) {
    // لكفاءة استخدام الذاكرة استخدمت .builder وذلك ليتم البناء فقط عند الحاجة يعني كل ما يعمل سكرول لتحت يلي وصلو فقط بعملو بناء
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF386A1B)),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: workspaces.length,
        itemBuilder: (BuildContext context, int index) {
          //حجيب البيانات من خلال ال index
          final item = workspaces[index];
          //ولكل item  هلقيت رجعلي البيانات الخاصة فيه
          return WorkspaceCard(
            title: item['title'],
            location: item['location'],
            imagePath: item['imagePath'],
            // استخدمي .toDouble() لضمان التحويل البرمجي
            rating: (item['rating'] as num).toDouble(),
          );
        },

      ),
    );
  }
}
