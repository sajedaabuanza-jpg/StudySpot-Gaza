import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../card/WorkspaceCard.dart';
import '../details/workspace_details_page.dart';

class al_mawasi extends StatefulWidget {
  const al_mawasi({super.key});

  @override
  State<al_mawasi> createState() => _al_mawasiState();
}

class _al_mawasiState extends State<al_mawasi> {
  // دالة آمنة تماماً لحساب التقييم لا تسبب أي كراش حتى لو كانت الداتا فارغة
  double _parseRating(String? qualityScores) {
    if (qualityScores == null || qualityScores.isEmpty) return 5.0;
    try {
      final pairs = qualityScores.split('|');
      double total = 0;
      int count = 0;
      for (var pair in pairs) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          final score = double.tryParse(parts[1].trim());
          if (score != null) {
            total += score;
            count++;
          }
        }
      }
      return count > 0 ? (total / count) : 5.0;
    } catch (e) {
      return 5.0; // في حال حدوث أي خطأ تعود بالتقييم الافتراضي 5
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF386A1B),
        title: const Text("المواصي", style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('workspaces').snapshots(),
        builder: (context, snapshot) {
          // 1. في حال وجود خطأ حقيقي في الاتصال أو السيرفر
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "خطأ في الاتصال: ${snapshot.error}",
                style: const TextStyle(fontFamily: 'Cairo', color: Colors.red),
              ),
            );
          }

          // 2. أثناء انتظار تحميل البيانات
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          // 3. فلترة المستندات بطريقة آمنة جداً (Null-Safe)
          final filteredDocs = docs.where((doc) {
            try {
              final data = doc.data() as Map<String, dynamic>?;
              if (data == null) return false;

              // جلب النص وفحصه بأمان دون تسبب بكراش في حال كان null
              final districtText = (data['district'] ?? data['destrict'] ?? '').toString().trim();
              return districtText.contains('مواص') || districtText.contains('المواصي');
            } catch (e) {
              return false; // تخطي أي مستند تالف أو مسبب للمشاكل
            }
          }).toList();

          // 4. حالة عدم وجود أي كافيهات مطابقة للمواصي
          if (filteredDocs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "لم يتم العثور على مساحات عمل مخزنة لمنطقة المواصي حالياً.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Cairo'),
                ),
              ),
            );
          }

          // 5. بناء القائمة بنجاح بعد التأكد والفلترة الأمنية
          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (BuildContext context, int index) {
              final data = filteredDocs[index].data() as Map<String, dynamic>;

              final item = {
                ...data,
                'id': filteredDocs[index].id,
                'district': data['district'] ?? data['destrict'] ?? 'المواصي',
              };

              double calculatedRating = _parseRating(item['quality_scores']);

              return WorkspaceCard(
                title: item['name'] ?? 'بدون اسم',
                location: "${item['city'] ?? ''} - ${item['district']}",
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