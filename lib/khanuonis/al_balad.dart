import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد الفايرستور
import 'package:nearest_work_space/card/WorkspaceCard.dart';
import 'package:nearest_work_space/details/workspace_details_page.dart'; // استيراد صفحة التفاصيل

class al_balad extends StatefulWidget {
  const al_balad({super.key});

  @override
  State<al_balad> createState() => _al_baladState();
}

class _al_baladState extends State<al_balad> {
  // دالة مساعدة لحساب التقييم من الـ Firestore
  double _parseRating(String? qualityScores) {
    if (qualityScores == null || qualityScores.isEmpty) return 5.0;
    try {
      final pairs = qualityScores.split('|');
      double total = 0;
      int count = 0;
      for (var pair in pairs) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          final score = double.tryParse(parts[1]);
          if (score != null) {
            total += score;
            count++;
          }
        }
      }
      return count > 0 ? (total / count) : 5.0;
    } catch (e) {
      return 5.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF386A1B),
        title: const Text("البلد", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      // استخدام StreamBuilder لجلب البيانات الحية والمباشرة من الفايرستور
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('workspaces')
            .where('district', isEqualTo: 'البلد') // جلب مساحات منطقة البلد فقط
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("حدث خطأ أثناء تحميل البيانات"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text("لا توجد مساحات عمل متاحة حالياً في هذه المنطقة"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (BuildContext context, int index) {
              final item = docs[index].data() as Map<String, dynamic>;
              double calculatedRating = _parseRating(item['quality_scores']);

              return WorkspaceCard(
                title: item['name'] ?? 'بدون اسم',
                location: "${item['city'] ?? ''} - ${item['district'] ?? ''}",
                imagePath: item['image_url'] ?? '',
                rating: calculatedRating,
                // حل المشكلة: تمرير الـ onTap وتفعيل الانتقال لصفحة التفاصيل مع تمرير بيانات الـ item
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => workspace_details_page(
                        workspace: item,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}