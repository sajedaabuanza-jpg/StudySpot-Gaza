import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../card/WorkspaceCard.dart';
import '../details/workspace_details_page.dart'; // تأكد من صحة مسار صفحة التفاصيل عندك

class al_mawasi extends StatefulWidget {
  const al_mawasi({super.key});

  @override
  State<al_mawasi> createState() => _al_mawasiState();
}

class _al_mawasiState extends State<al_mawasi> {
  // دالة حساب التقييم
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
        title: const Text("المواصي", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        // جلب المجموعة كاملة بدون فلترة معقدة من السيرفر لتفادي مشاكل الفراغات وحروف الـ الـ (ي / ى)
        stream: FirebaseFirestore.instance.collection('workspaces').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("حدث خطأ أثناء تحميل البيانات"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          // الفلترة الذكية داخل الكود: نقوم بتنظيف النصوص من أي مسافات زائدة تماماً
          final filteredDocs = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;

            // تحويل النص إلى سلسلة، تنظيف المسافات من الطرفين، واستبدال الفراغات الداخلية إن وجدت
            final districtText = (data['district'] ?? '').toString().trim();

            // المطابقة المرنة: تفحص إن كانت الكلمة تحتوي على "مواصي" بأي شكل (مع أو بدون مسافات)
            return districtText.contains('المواصي') || districtText.contains('مواصي');
          }).toList();

          // إذا كانت القائمة فارغة بعد الفلترة الذكية
          if (filteredDocs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "لم يتم العثور على مساحات عمل مخزنة لمنطقة المواصي.\nتأكد من اسم الـ Collection في الفايرستور.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (BuildContext context, int index) {
              final item = filteredDocs[index].data() as Map<String, dynamic>;
              double calculatedRating = _parseRating(item['quality_scores']);

              return WorkspaceCard(
                title: item['name'] ?? 'بدون اسم',
                location: "${item['city'] ?? ''} - ${item['district'] ?? ''}",
                imagePath: item['image_url'] ?? '',
                rating: calculatedRating,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => workspace_details_page(workspace: item),
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