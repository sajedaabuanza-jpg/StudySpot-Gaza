import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyspot/card/WorkspaceCard.dart';
import 'package:studyspot/details/workspace_details_page.dart';

import 'package:studyspot/add_workspace_screen.dart';
import 'package:studyspot/favorite/favorite.dart';
class AlZawayda extends StatefulWidget {
  const AlZawayda({super.key});

  @override
  State<AlZawayda> createState() => _AlZawaydaState();
}

class _AlZawaydaState extends State<AlZawayda> {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF386A1B),
        title: const Text("الزوايدة", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const favorite()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddWorkspaceScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF386A1B),
        icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
        label: const Text(
          'أضف مساحتك',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('workspaces')
            .where('district', isEqualTo: 'الزوايدة')
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
              final data = docs[index].data() as Map<String, dynamic>;
              final item = {
                ...data,
                'id': docs[index].id,
              };
              double calculatedRating = _parseRating(item['quality_scores']);

              return WorkspaceCard(
                workspaceId: item['id'].toString(),
                title: item['name'] ?? 'بدون اسم',
                location: "${item['city'] ?? ''} - ${item['district'] ?? ''}",
                imagePath: item['image_url'] ?? '',
                rating: calculatedRating,
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