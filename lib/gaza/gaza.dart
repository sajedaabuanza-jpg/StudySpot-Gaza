import 'package:flutter/material.dart';
import 'package:nearest_work_space/button/button.dart';
import 'package:nearest_work_space/gaza/al_nusser.dart';
import 'package:nearest_work_space/gaza/alremal.dart';
import 'package:nearest_work_space/gaza/shamalGaza.dart';
import 'package:nearest_work_space/gaza/talallhawa.dart';
import 'altofah.dart';

class gaza extends StatelessWidget {
  const gaza({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true, // لتمتد الخلفية خلف الـ AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar شفاف للتصميم الجديد
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF386A1B)),
      ),
      body: Stack(
        children: [
          // 1. الخلفية (الشعار والأوراق السفلية فقط)
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

          // 2. المحتوى البرمجي بتوزيع المسافات الجديد
          SafeArea(
            child: Column(
              children: [
                // إنزال العناصر لأسفل لترك مساحة للشعار (إزاحة 12% من الارتفاع)
                SizedBox(height: screenHeight * 0.12),

                // شريط الخطوات (1-2-3) - المرحلة الثانية (المنطقة)
                _buildStepper(2),

                // شريط المسار (غزة / اختر المنطقة)
                _buildPathBar("غزة", "اختر المنطقة"),

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

                // قائمة المناطق (المنطق الأصلي الخاص بكِ داخل التصميم الجديد)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    children: [
                      _buildRegionCard(context, 'النصر', Icons.location_city, const al_nusser()),
                      _buildRegionCard(context, 'التفاح', Icons.map_outlined, const altofah()),
                      _buildRegionCard(context, 'الرمال', Icons.apartment, const alremal()),
                      _buildRegionCard(context, 'تل الهوا', Icons.business_outlined, const talallhawa()),
                      _buildRegionCard(context, 'شمال غزة', Icons.explore_outlined, const shamalGaza()),
                      const SizedBox(height: 30), // مسافة أمان سفلية
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

  // --- شريط الخطوات البرمجي (Stepper) ---
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

  // --- شريط المسار (Breadcrumbs) ---
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

  // --- كرت المناطق البرمجي (المنطق + التصميم) ---
  Widget _buildRegionCard(BuildContext context, String title, IconData icon, Widget targetPage) {
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
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage)),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF386A1B),
        iconTheme: const IconThemeData(color: Colors.white), // تلوين زر الرجوع بالأبيض
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
          padding: const EdgeInsets.only(top: 180), // تقليل المسافة قليلاً لتناسب زيادة عدد الأزرار دون حدوث Overflow
          child: SingleChildScrollView( // إضافة سكرول لحماية الشاشات الصغيرة من مشاكل الـ Overflow
            child: Column(
              children: [
                // 1. زر النصر
                button(
                  color: Colors.white,
                  text: 'النصر',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const al_nusser()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 15),

                // 2. زر التفاح
                button(
                  color: Colors.white,
                  text: 'التفاح',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const altofah()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 15),

                // 3. زر الرمال
                button(
                  color: Colors.white,
                  text: 'الرمال',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const alremal()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 15),

                // 4. زر تل الهوا
                button(
                  color: Colors.white,
                  text: 'تل الهوا',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const talallhawa()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 15),

                // 5. زر شمال غزة
                button(
                  color: Colors.white,
                  text: 'شمال غزة',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const shamalGaza()));
                  },
                  textColor: const Color(0xFF386A1B),
                ),
                const SizedBox(height: 20), // مسافة أمان بالأسفل
              ],
            ),
          ),
        ),
      ),
    );
  }
>>>>>>> 7a76ac2e8940acf768aa710c179f69c9996da830
}