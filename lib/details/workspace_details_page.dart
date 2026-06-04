import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class workspace_details_page extends StatelessWidget {
  final Map<String, dynamic> workspace;

  const workspace_details_page({
    super.key,
    required this.workspace,
  });

  // 1. دالة حساب متوسط التقييم العام من حقل quality_scores
  double _getAverageRating(String? qualityScores) {
    if (qualityScores == null || qualityScores.isEmpty) return 4.0;
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
      return count > 0 ? (total / count) : 4.0;
    } catch (e) {
      return 4.0;
    }
  }

  // 2. دالة استخراج قيم الجودة الفردية للمؤشرات
  double _getSpecificScore(String? qualityScores, String key) {
    if (qualityScores == null || qualityScores.isEmpty) return 3.0;
    try {
      final pairs = qualityScores.split('|');
      for (var pair in pairs) {
        final parts = pair.split(':');
        if (parts.length == 2 && parts[0].trim().toLowerCase() == key.toLowerCase()) {
          return double.tryParse(parts[1]) ?? 3.0;
        }
      }
    } catch (_) {}
    return 3.0;
  }

  // 3. دالة تفكيك حقل خطط الأسعار (pricing_plans) ديناميكياً
  List<Map<String, String>> _parsePricingPlans(String? pricingPlansStr) {
    if (pricingPlansStr == null || pricingPlansStr.isEmpty) {
      return [
        {"title": "السعر", "price": "غير محدد", "sub": "يرجى التواصل لمعرفة السعر"}
      ];
    }
    List<Map<String, String>> plans = [];
    try {
      final parts = pricingPlansStr.split('|');
      for (var part in parts) {
        final kv = part.split('=');
        if (kv.length == 2) {
          plans.add({
            "title": kv[0].trim(),
            "price": kv[1].trim(),
            "sub": kv[0].trim().contains("شهر") ? "دخول غير محدود طوال الشهر" : "سعر اقتصادي"
          });
        }
      }
    } catch (_) {}

    if (plans.isEmpty) {
      plans.add({"title": "تكلفة الدخول", "price": pricingPlansStr, "sub": ""});
    }
    return plans;
  }

  @override
  Widget build(BuildContext context) {
    double rating = _getAverageRating(workspace['quality_scores']);

    List<String> servicesList = (workspace['filters_csv'] ?? '').toString().split(',');
    servicesList = servicesList.map((s) => s.trim().toLowerCase()).where((s) => s.isNotEmpty).toList();

    List<Map<String, String>> pricingPlans = _parsePricingPlans(workspace['pricing_plans']);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5E8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. هيدر الصفحة والصورة العلوية
            Stack(
              children: [
                SizedBox(
                  height: 320,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: Image.network(
                      workspace['image_url'] ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 320,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.65)],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Positioned(
                  top: 40,
                  right: 20,
                  child: Icon(Icons.favorite_border, color: Colors.white, size: 30),
                ),
                Positioned(
                  top: 45,
                  left: 100,
                  right: 100,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD97706),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bolt, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          workspace['electricity_details'] != null && workspace['electricity_details'].toString().contains("24")
                              ? "كهرباء متوفرة دائمًا"
                              : "كهرباء متوفرة",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 25,
                  right: 25,
                  left: 25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        workspace['name'] ?? 'مساحة عمل',
                        style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${workspace['city'] ?? ''} - ${workspace['district'] ?? ''}",
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  // 2. ساعات العمل والتقييم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD97706), width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          workspace['working_hours'] ?? 'غير محدد',
                          style: const TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 5),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < rating.round() ? Icons.star : Icons.star_border,
                                color: Colors.orange,
                                size: 22,
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 3. شارات الفلاتر
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.end,
                    children: [
                      if (servicesList.contains('drinks') || servicesList.contains('food') || servicesList.contains('cafe'))
                        _buildFilterBadge("طعام ومشروبات", Icons.fastfood, const Color(0xFFD4E6C1)),
                      if (servicesList.contains('wc'))
                        _buildFilterBadge("دورات مياه", Icons.wc, const Color(0xFFD4E6C1)),
                      _buildFilterBadge("مقاعد مريحة", Icons.chair, const Color(0xFFD4E6C1)),
                      _buildFilterBadge("بيئة عمل", Icons.laptop, const Color(0xFFBFE3E8)),
                      if (servicesList.contains('internet') || servicesList.contains('wifi'))
                        _buildFilterBadge("واي فاي", Icons.wifi, const Color(0xFFD4E6C1)),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // 4. خطط الأسعار
                  _buildSectionTitle("الأسعار وخطط الاشتراك", Icons.payments),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pricingPlans.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildPriceCard(
                            pricingPlans[index]['title']!,
                            pricingPlans[index]['price']!,
                            pricingPlans[index]['sub']!,
                            isFullWidth: true
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),

                  // 5. مؤشرات الجودة
                  _buildSectionTitle("مؤشرات الجودة الحاليّة", Icons.analytics_outlined),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildQualityIndicator("الإنترنت", _getSpecificScore(workspace['quality_scores'], 'internet'), Colors.blue),
                        _buildQualityIndicator("الإستقرار", _getSpecificScore(workspace['quality_scores'], 'stability'), Colors.blueAccent),
                        _buildQualityIndicator("الكهرباء", _getSpecificScore(workspace['quality_scores'], 'electricity'), Colors.orange),
                        _buildQualityIndicator("البيئة والعزل", _getSpecificScore(workspace['quality_scores'], 'environment'), Colors.green),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailStrip(workspace['electricity_details'] ?? "لا توجد تفاصيل إضافية للكهرباء حالياً", Icons.bolt),
                  const SizedBox(height: 10),
                  _buildDetailStrip(workspace['internet_details'] ?? "تفاصيل شبكة الاتصال متوفرة بالمكان", Icons.wifi, isOrange: true),
                  const SizedBox(height: 25),

                  // 6. شبكة المرافق
                  _buildSectionTitle("الخدمات والمرافق المتاحة", Icons.grid_view),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _buildServiceCard("دورات مياه", Icons.wc, isUnavailable: !servicesList.contains('wc')),
                      _buildServiceCard("طعام ومشروبات", Icons.local_cafe, isUnavailable: !servicesList.contains('drinks') && !servicesList.contains('food') && !servicesList.contains('cafe')),
                      _buildServiceCard("دراسة وهدوء", Icons.person, isUnavailable: false),
                      _buildServiceCard("جلسات مجموعات", Icons.group, isUnavailable: false),
                      _buildServiceCard("طباعة وأوراق", Icons.print, isUnavailable: !servicesList.contains('print')),
                      _buildServiceCard("قريب من خط السير", Icons.directions_bus, isUnavailable: !servicesList.contains('transport')),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // 7. جدول الوصول
                  _buildSectionTitle("الوقت وتفاصيل الوصول", Icons.access_time),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        _buildTableCell("أوقات العمل اليومية", workspace['working_hours'] ?? "غير مححدد"),
                        _buildTableCell("أقرب معلم مميز للمكان", workspace['nearest_landmark'] ?? "غير محدد"),
                        _buildTableCell("طبيعة المكان الجغرافية", workspace['district'] ?? "غير محدد"),
                        _buildTableCell("حالة التحقق والوصول", "مساحة عمل موثقة", isVerified: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 8. التواصل عبر الهاتف / واتساب
                  _buildSectionTitle("تواصل سريع مع الإدارة", Icons.call),
                  const SizedBox(height: 12),
                  if (workspace['phone'] != null && workspace['phone'].toString().isNotEmpty)
                    GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse("https://wa.me/${workspace['phone']}");
                        if (await canLaunchUrl(url)) await launchUrl(url);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              workspace['phone'].toString(),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.chat, color: Colors.green, size: 28),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 25),

                  // 9. زر الموقع الجغرافي
                  if (workspace['location_url'] != null && workspace['location_url'].toString().isNotEmpty)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF386A1B),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      icon: const Icon(Icons.location_on, color: Colors.white),
                      label: const Text("الذهاب إلى الموقع على الخريطة", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        final Uri url = Uri.parse(workspace['location_url'].toString());
                        if (await canLaunchUrl(url)) await launchUrl(url);
                      },
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, color: Color(0xFF386A1B), fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Icon(icon, color: const Color(0xFF386A1B), size: 20),
      ],
    );
  }

  Widget _buildFilterBadge(String text, IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(width: 5),
          Icon(icon, size: 14, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildPriceCard(String duration, String price, String label, {bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(price, style: const TextStyle(color: Color(0xFFC0392B), fontSize: 20, fontWeight: FontWeight.bold)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(duration, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
              if (label.isNotEmpty) Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualityIndicator(String title, double score, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("${score.toStringAsFixed(0)}/5", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: score / 5,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 15),
          SizedBox(
            width: 85,
            child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStrip(String text, IconData icon, {bool isOrange = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOrange ? const Color(0xFFFEF3C7) : const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: isOrange ? const Color(0xFFB45309) : const Color(0xFF2E7D32), fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: isOrange ? const Color(0xFFB45309) : const Color(0xFF2E7D32), size: 18),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, {bool isUnavailable = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isUnavailable ? Colors.grey : Colors.black87,
              decoration: isUnavailable ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: isUnavailable ? Colors.grey : const Color(0xFF386A1B), size: 20),
        ],
      ),
    );
  }

  Widget _buildTableCell(String label, String value, {bool isVerified = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isVerified) const Icon(Icons.check, color: Colors.green, size: 18),
              const SizedBox(width: 4),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}