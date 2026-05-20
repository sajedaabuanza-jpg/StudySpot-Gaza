import 'package:flutter/material.dart';

void main() {
  runApp(const StudySpotApp());
}

class StudySpotApp extends StatelessWidget {
  const StudySpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudySpot Gaza',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto', 
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // متغيرات الفلترة
  String selectedArea = 'الكل';
  bool hasElectricity = false;
  bool hasInternet = false;

  final List<String> areas = ['الكل', 'غزة', 'خانيونس', 'الوسطى', 'رفح'];

  // قاعدة بيانات تجريبية للمساحات المتاحة في قطاع غزة
  final List<Map<String, dynamic>> allSpots = [
    {
      'name': 'حاضنة غزة التكنولوجية (Gaza Sky Geeks)',
      'area': 'غزة',
      'electricity': true,
      'internet': true,
      'hours': '8:00 ص - 6:00 م',
      'details': 'مساحة عمل مخصصة للمطورين والمستقلين مع توفر طاقة بديلة مستمرة.'
    },
    {
      'name': 'مساحة عمل وبحث (💡 إبداع)',
      'area': 'غزة',
      'electricity': true,
      'internet': false, // حالياً الإنترنت متقطع
      'hours': '9:00 ص - 5:00 م',
      'details': 'بيئة هادئة جداً للدراسة مع توفر خط شحن ومولدات.'
    },
    {
      'name': 'مركز التدريب الشبابي المشترك',
      'area': 'خانيونس',
      'electricity': true,
      'internet': true,
      'hours': '8:30 ص - 4:30 م',
      'details': 'إنترنت فايبر مستقر طوال ساعات العمل، وقاعات دراسية مجهزة.'
    },
    {
      'name': 'مكتبة ومساحة أثر للدراسة',
      'area': 'الوسطى',
      'electricity': false, // طاقة بديلة محدودة
      'internet': true,
      'hours': '9:00 ص - 4:00 م',
      'details': 'إنترنت متاح للطلاب، يفضل إحضار لابتوب مشحون مسبقاً.'
    },
    {
      'name': 'مركز رفح الثقافي للشباب',
      'area': 'رفح',
      'electricity': true,
      'internet': true,
      'hours': '8:00 ص - 3:00 م',
      'details': 'متوفر طاقة شمسية كاملة وشبكة إنترنت مخصصة للبحوث الجامعية.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // دالة الفلترة الذكية بناءً على اختيارات المستخدم
    List<Map<String, dynamic>> filteredSpots = allSpots.where((spot) {
      bool matchesArea = selectedArea == 'الكل' || spot['area'] == selectedArea;
      bool matchesElectricity = !hasElectricity || spot['electricity'] == true;
      bool matchesInternet = !hasInternet || spot['internet'] == true;
      return matchesArea && matchesElectricity && matchesInternet;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudySpot Gaza - أماكن الدراسة والعمل'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ابحث عن مساحة عمل أو دراسة متوفرة بحسب الخدمات الحالية:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // كرت الفلاتر العلوي لتنظيم شكل الواجهة
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('اختر المنطقة: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 15),
                          DropdownButton<String>(
                            value: selectedArea,
                            items: areas.map((String area) {
                              return DropdownMenuItem<String>(
                                value: area,
                                child: Text(area),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedArea = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      CheckboxListTile(
                        title: const Text('توفر كهرباء / طاقة بديلة مستمرة'),
                        value: hasElectricity,
                        activeColor: Colors.teal,
                        dense: true,
                        onChanged: (value) {
                          setState(() {
                            hasElectricity = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('توفر إنترنت مستقر (WiFi)'),
                        value: hasInternet,
                        activeColor: Colors.teal,
                        dense: true,
                        onChanged: (value) {
                          setState(() {
                            hasInternet = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              Text(
                'النتائج المتاحة (${filteredSpots.length}):',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 10),
              
              // قائمة عرض المساحات والأماكن المفلترة بشكل ديناميكي
              Expanded(
                child: filteredSpots.isEmpty
                    ? const Center(
                        child: Text(
                          'عذراً، لا توجد أماكن تطابق هذه الفلاتر حالياً.\nجرّب اختيار منطقة أخرى أو تقليل القيود.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredSpots.length,
                        itemBuilder: (context, index) {
                          final spot = filteredSpots[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              title: Text(
                                spot['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(spot['details'], style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Chip(
                                        label: Text('📍 ${spot['area']}'),
                                        backgroundColor: Colors.teal.withOpacity(0.1),
                                      ),
                                      const SizedBox(width: 8),
                                      Chip(
                                        label: Text('🕒 ${spot['hours']}'),
                                        backgroundColor: Colors.orange.withOpacity(0.1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    spot['electricity'] ? Icons.bolt : Icons.power_off,
                                    color: spot['electricity'] ? Colors.amber : Colors.grey,
                                  ),
                                  const SizedBox(height: 4),
                                  Icon(
                                    spot['internet'] ? Icons.wifi : Icons.wifi_off,
                                    color: spot['internet'] ? Colors.blue : Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}