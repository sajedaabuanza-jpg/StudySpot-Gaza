import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyspot/favorite/favorite.dart';
import '../card/WorkspaceCard.dart';
import 'package:studyspot/add_workspace_screen.dart';
import 'package:studyspot/filter_page.dart';
import '../details/workspace_details_page.dart';

class DistrictHome extends StatefulWidget {
  final String district;
  final String title;

  const DistrictHome({
    super.key,
    required this.district,
    required this.title,
  });

  @override
  State<DistrictHome> createState() => _DistrictHomeState();
}

class _DistrictHomeState extends State<DistrictHome> {
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
    // اللون الأخضر المعتمد في التطبيق لتوحيد الهوية البصرية
    const Color primaryGreen = Color(0xFF386A1B);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        // تم إزالة زر المفضلة من هنا لنقله إلى الشريط السفلي
        actions: const [],
      ),
      backgroundColor: Colors.white,

      // 1. الزر الدائري البارز في المنتصف (الرئيسية) مثل FilterPage
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // الرجوع للصفحة الرئيسية
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        backgroundColor: primaryGreen,
        shape: const CircleBorder(),
        child: const Icon(Icons.home, color: Colors.white, size: 30),
      ),

      // 2. شريط القائمة السفلي الأنيق المجوف من المنتصف
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl, // لتبدأ العناصر من اليمين إلى اليسار بالتناسق
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(), // الشكل المجوف تحت زر البيت
          notchMargin: 8.0,
          color: Colors.white,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // زر المفضلة على اليمين
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const favorite()),
                    );
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border, color: Colors.grey),
                      Text(
                        'المفضلة',
                        style: TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 40), // فراغ في المنتصف ليعطي مساحة للزر الدائري البارز

                // زر أضف مساحتك على اليسار
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddWorkspaceScreen(),
                      ),
                    );
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.grey),
                      Text(
                        'أضف مساحتك',
                        style: TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('workspaces').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("حدث خطأ أثناء تحميل البيانات"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          // الفلترة الذكية داخل الكود
          final filteredDocs = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final districtText = (data['district'] ?? '').toString().trim();
            return districtText == widget.district;
          }).toList();

          // ترتيب النتائج حسب أعلى تقييم
          filteredDocs.sort((a, b) {
            final dataA = a.data() as Map<String, dynamic>;
            final dataB = b.data() as Map<String, dynamic>;

            final ratingA = _parseRating(dataA['quality_scores']);
            final ratingB = _parseRating(dataB['quality_scores']);

            return ratingB.compareTo(ratingA);
          });

          if (filteredDocs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "لم يتم العثور على مساحات عمل مخزنة لهذه المنطقة.\nتأكد من اسم الـ Collection في الفايرستور.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: const BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "أهلاً بك في",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "اختر وجهتك المثالية للدراسة",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // مربع البحث
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FilterPage(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 15),
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 10),
                        Text(
                          "ابحث عن مساحة عمل...",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "الأبرز",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredDocs.length,
                  padding: const EdgeInsets.only(bottom: 80),                  itemBuilder: (BuildContext context, int index) {
                    final data = filteredDocs[index].data() as Map<String, dynamic>;

                    final item = {
                      ...data,
                      'id': filteredDocs[index].id,
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
                            builder: (context) => workspace_details_page(workspace: item),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}