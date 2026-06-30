import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyspot/details/add_workspace_screen.dart';
import 'package:studyspot/favorite/favorite.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // متغيرات لحفظ حالة الفلاتر السريعة (الأفقية)
  String selectedQuickFilter = 'الأبرز';
  final List<String> quickFilters = ['الأبرز', 'واي فاي', 'كهرباء', 'مواصلات'];

  // متحكم البحث النصي
  final TextEditingController searchController = TextEditingController();

  // خريطة (Map) لحفظ حالة الخدمات والمرافق (هل هي مختارة أم لا)
  // هذه الخدمات مطابقة تماماً لحقل filters_csv الموجود في Firebase
  final Map<String, bool> servicesStatus = {
    'كهرباء': false,
    'مشروبات': false,
    'واي فاي': false,
    'دورات مياه': false,
    'مواصلات': false,
  };

  // خريطة تربط اسم الخدمة بالعربي بمقابلها في الـ filters_csv بالإنجليزي
  final Map<String, String> serviceToFilter = {
    'كهرباء': 'electricity',
    'مشروبات': 'drinks',
    'واي فاي': 'internet',
    'دورات مياه': 'wc',
    'مواصلات': 'transport',
  };

  // خريطة مطابقة للأيقونات الخاصة بكل خدمة
  final Map<String, IconData> serviceIcons = {
    'كهرباء': Icons.flash_on,
    'مشروبات': Icons.local_cafe,
    'واي فاي': Icons.wifi,
    'دورات مياه': Icons.wc,
    'مواصلات': Icons.directions_bus,
  };

  // قائمة النتائج القادمة من Firebase
  List<Map<String, dynamic>> results = [];

  // متغير لمعرفة هل نحن في حالة تحميل أم لا
  bool isLoading = false;

  // متغير لمعرفة هل تم الضغط على زر البحث من قبل (لإخفاء الرسائل في البداية)
  bool hasSearched = false;

  // دالة الفلترة الرئيسية - تجيب جميع الأماكن من كل المدن وتفلترها
  Future<void> fetchFilteredResults() async {
    setState(() {
      isLoading = true; // إظهار مؤشر التحميل
      hasSearched = true;
    });

    // جلب كل الأماكن من كل المدن (بدون أي فلترة على مستوى السيرفر)
    final snapshot = await FirebaseFirestore.instance
        .collection('workspaces')
        .get();

    // تحديد الفلاتر المختارة من المستخدم (الخدمات)
    final List<String> activeFilters = servicesStatus.entries
        .where((entry) => entry.value == true)
        .map((entry) => serviceToFilter[entry.key]!)
        .toList();

    // نص البحث الذي كتبه المستخدم (بعد إزالة الفراغات الزائدة)
    final String searchQuery = searchController.text.trim();

    // تصفية النتائج محلياً بناءً على filters_csv ونص البحث
    final filtered = snapshot.docs.where((doc) {
      final data = doc.data();

      // فلترة الخدمات (filters_csv)
      final String filtersCsv = data['filters_csv'] ?? '';
      final List<String> placeFilters = filtersCsv.split(',');

      final bool matchesFilters = activeFilters.isEmpty
          ? true
          : activeFilters.every((f) => placeFilters.contains(f));

      // فلترة نص البحث (الاسم أو المدينة أو المنطقة)
      bool matchesSearch = true;
      if (searchQuery.isNotEmpty) {
        final String name = (data['name'] ?? '').toString();
        final String city = (data['city'] ?? '').toString();
        final String district = (data['district'] ?? '').toString();

        matchesSearch = name.contains(searchQuery) ||
            city.contains(searchQuery) ||
            district.contains(searchQuery);
      }

      return matchesFilters && matchesSearch;
    }).map((doc) => doc.data()).toList();

    setState(() {
      results = filtered; // تحديث قائمة النتائج
      isLoading = false; // إخفاء مؤشر التحميل
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // حساب عدد الخدمات المختارة حالياً لعرضها في زر النتائج
    int selectedCount = servicesStatus.values.where((element) => element == true).length;

    // اللون الأخضر الأساسي للتطبيق المستوحى من التصميم
    final Color primaryGreen = const Color(0xFF2A663B);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F5), // خلفية الصفحة المائلة للأخضر الفاتح جداً
      body: Directionality(
        textDirection: TextDirection.rtl, // لجعل التطبيق يبدأ من اليمين إلى اليسار
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. الجزء العلوي الأخضر (Header)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 25, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'اختر وجهتك للعمل والإبداع',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'أفضل أماكن العمل',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    // حقل البحث الأبيض
                    TextField(
                      controller: searchController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'ابحث عن مساحة عمل...',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // 2. قائمة الفلاتر السريعة الأفقية
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: quickFilters.length,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemBuilder: (context, index) {
                    final filterName = quickFilters[index];
                    final isSelected = selectedQuickFilter == filterName;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(filterName),
                        selected: isSelected,
                        selectedColor: primaryGreen,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: isSelected ? primaryGreen : Colors.black12),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedQuickFilter = filterName;

                              // ربط الفلتر السريع مع فلتر الخدمة المقابل تلقائياً
                              servicesStatus.updateAll((key, value) => false);
                              if (filterName == 'واي فاي') {
                                servicesStatus['واي فاي'] = true;
                              } else if (filterName == 'كهرباء') {
                                servicesStatus['كهرباء'] = true;
                              } else if (filterName == 'مواصلات') {
                                servicesStatus['مواصلات'] = true;
                              }
                              // "الأبرز" لا يفعّل أي فلتر، يعرض كل النتائج
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              // 3. قسم فلتر حسب الخدمات والمرافق
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'فلتر حسب الخدمات والمرافق',
                      style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    // الـ Wrap لتوزيع الأزرار بشكل شبكي مرن ينزل للسطر الجديد تلقائياً
                    Wrap(
                      spacing: 10, // المسافة الأفقية بين الأزرار
                      runSpacing: 10, // المسافة العمودية بين الأسطر
                      children: servicesStatus.keys.map((String serviceName) {
                        final isSelected = servicesStatus[serviceName]!;
                        return FilterChip(
                          avatar: Icon(
                            serviceIcons[serviceName],
                            size: 18,
                            color: isSelected ? primaryGreen : Colors.black54,
                          ),
                          label: Text(serviceName),
                          selected: isSelected,
                          showCheckmark: false, // إلغاء علامة الصح الافتراضية للحفاظ على التصميم
                          selectedColor: const Color(0xFFEAF4EC), // لون خلفية خفيف عند الاختيار
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? primaryGreen : Colors.black87,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: isSelected ? primaryGreen : Colors.black12),
                          ),
                          onSelected: (bool selected) {
                            setState(() {
                              servicesStatus[serviceName] = selected;
                              // إعادة الفلتر السريع إلى "الأبرز" عند التعديل اليدوي على الخدمات
                              selectedQuickFilter = 'الأبرز';
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 4. زر عرض النتائج في الأسفل
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: fetchFilteredResults, // استدعاء دالة الفلترة عند الضغط
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'عرض النتائج',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        // الدائرة الصغيرة التي تحتوي على عدد الفلاتر المختارة
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$selectedCount',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 5. عرض النتائج بعد الضغط على الزر
              if (isLoading)
                // مؤشر التحميل أثناء جلب البيانات من Firebase
                const Center(child: CircularProgressIndicator(color: Color(0xFF2A663B)))
              else if (results.isNotEmpty)
                // قائمة النتائج
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${results.length} نتيجة',
                        style: const TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      const SizedBox(height: 10),
                      // بناء كرت لكل مكان في النتائج
                      ...results.map((place) => _buildPlaceCard(place, primaryGreen)).toList(),
                    ],
                  ),
                )
              else if (hasSearched && !isLoading && results.isEmpty)
                // رسالة عدم وجود نتائج (تظهر فقط بعد الضغط على زر البحث)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'لا توجد أماكن تطابق بحثك أو الفلاتر المختارة',
                      style: TextStyle(color: Colors.black45, fontSize: 14),
                    ),
                  ),
                ),

              const SizedBox(height: 100), // مساحة إضافية للنزول تحت الشريط السفلي
            ],
          ),
        ),
      ),

      // 6. الزر الدائري البارز في المنتصف (الرئيسية)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // الرجوع للصفحة الرئيسية عند الضغط على زر البيت
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        backgroundColor: primaryGreen,
        shape: const CircleBorder(),
        child: const Icon(Icons.home, color: Colors.white, size: 30),
      ),

      // 7. شريط القائمة السفلي الأنيق المجوف من المنتصف
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(), // لإعطاء الشكل المجوف تحت زر البيت
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
                    // هنا سيتم إضافة صفحة المفضلة لاحقاً
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const favorite()));
                    print("تم الضغط على المفضلة");
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border, color: Colors.grey),
                      Text('المفضلة', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 40), // فراغ في المنتصف ليعطي مساحة للزر الدائري البارز
                // زر أضف مساحتك على اليسار
                GestureDetector(
                  onTap: () {
                    // هنا سيتم إضافة صفحة إضافة مساحة لاحقاً
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddWorkspaceScreen(),
                            ),
                          );
                    print("تم الضغط على أضف مساحتك");
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.grey),
                      Text('أضف مساحتك', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- كرت عرض المكان في النتائج ---
  Widget _buildPlaceCard(Map<String, dynamic> place, Color primaryGreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اسم المكان
            Text(
              place['name'] ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 6),
            // المدينة والمنطقة
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${place['city'] ?? ''} - ${place['district'] ?? ''}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // ساعات العمل
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  place['working_hours'] ?? '',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}