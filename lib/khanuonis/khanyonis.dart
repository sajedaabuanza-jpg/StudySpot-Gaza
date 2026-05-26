import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:nearest_work_space/button/button.dart';
import 'package:nearest_work_space/khanuonis/al_mawasi.dart'; // استيراد صفحة المواصي القادمة من الفايرستور
>>>>>>> 7a76ac2e8940acf768aa710c179f69c9996da830

class khanyonis extends StatelessWidget {
  const khanyonis({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
<<<<<<< HEAD
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF386A1B)),
      ),
      body: Stack(
        children: [
          // 1. الخلفية الثابتة (selectArea.png)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/selectArea.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // 2. المحتوى البرمجي لخانيونس
          SafeArea(
            child: Column(
              children: [
                // الإزاحة المطلوبة لإنزال العناصر (12% من الارتفاع)
                SizedBox(height: screenHeight * 0.12),

                // شريط الخطوات (Stepper) - المرحلة الثانية
                _buildStepper(2),

                // شريط المسار (خانيونس / اختر المنطقة)
                _buildPathBar("خانيونس", "اختر المنطقة"),

                const Text(
                  "اختر منطقتك",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF386A1B),
                    fontFamily: 'Cairo',
                  ),
                ),

                const SizedBox(height: 20),

                // قائمة مناطق خانيونس
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    children: [
                      _buildRegionCard(context, 'البلد', Icons.location_city, null),
                      _buildRegionCard(context, 'المواصي', Icons.waves, null),
                      _buildRegionCard(context, 'مدينة حمد والقرارة', Icons.business_outlined, null),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- الـ Widgets المساعدة (نفس الستايل الموحد للتطبيق) ---

  Widget _buildStepper(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle("3", "تأكيد", currentStep >= 3),
        _buildLine(currentStep > 2),
        _buildStepCircle("2", "المنطقة", currentStep >= 2),
        _buildLine(currentStep > 1),
        _buildStepCircle("1", "المدينة", currentStep >= 1, isCompleted: true),
      ],
    );
  }

  Widget _buildStepCircle(String step, String title, bool isActive, {bool isCompleted = false}) {
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF386A1B) : (isActive ? const Color(0xFF9DC478) : Colors.white),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF386A1B).withOpacity(0.2)),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(step, style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 6),
        Text(title, style: TextStyle(fontSize: 11, color: isActive ? const Color(0xFF386A1B) : Colors.grey, fontFamily: 'Cairo')),
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Container(
      width: 35,
      height: 2,
      margin: const EdgeInsets.only(bottom: 22),
      color: isActive ? const Color(0xFF386A1B) : Colors.grey.shade300,
    );
  }

  Widget _buildPathBar(String city, String region) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(region, style: const TextStyle(color: Color(0xFF386A1B), fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text("/", style: TextStyle(color: Colors.grey)),
          ),
          Text(city, style: const TextStyle(color: Color(0xFF9DC478), fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _buildRegionCard(BuildContext context, String title, IconData icon, Widget? targetPage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        onTap: () {
          if (targetPage != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
          }
        },
        leading: const Icon(Icons.arrow_back_ios, size: 14, color: Color(0xFF386A1B)),
        trailing: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F8E9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF386A1B), size: 28),
        ),
        title: Text(
          title,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF333333), fontFamily: 'Cairo'),
        ),
      ),
    );
  }
=======
      appBar: AppBar(
        backgroundColor: const Color(0xFF386A1B),
        iconTheme: const IconThemeData(color: Colors.white), // تلوين زر الرجوع باللون الأبيض
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ch_area.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 220),
          child: Column(
            children: [
              // زر البلد
              button(
                color: Colors.white,
                text: 'البلد',
                onPressed: () {
                  // يمكنك ربطها لاحقاً بنفس طريقة المواصي عند تجهيز صفحتها
                },
                textColor: const Color(0xFF386A1B),
              ),
              const SizedBox(height: 15),

              // زر المواصي (تم ربطه وتفعيله بنجاح مع الفايرستور)
              button(
                color: Colors.white,
                text: 'المواصي',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const al_mawasi()),
                  );
                },
                textColor: const Color(0xFF386A1B),
              ),
              const SizedBox(height: 15),

              // زر مدينة حمد والقرارة
              button(
                color: Colors.white,
                text: 'مدينة حمد والقرارة',
                onPressed: () {
                  // يمكنك ربطها لاحقاً بنفس طريقة المواصي عند تجهيز صفحتها
                },
                textColor: const Color(0xFF386A1B),
              ),
            ],
          ),
        ),
      ),
    );
  }
>>>>>>> 7a76ac2e8940acf768aa710c179f69c9996da830
}