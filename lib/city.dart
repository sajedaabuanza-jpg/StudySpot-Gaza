import 'package:studyspot/filter_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyspot/al-westa/al-westa.dart';
import 'package:studyspot/favorite/favorite.dart';
import 'package:studyspot/khanuonis/khanyonis.dart';
import 'package:studyspot/gaza/gaza.dart';
import 'package:studyspot/googleLogin/AuthService.dart';
import 'package:studyspot/googleLogin/googleLogin.dart' as loginUi;

bool isDarkMode = false;
bool isEnglish = false;

class city extends StatefulWidget {
  const city({super.key});

  @override
  State<city> createState() => _cityState();
}

class _cityState extends State<city> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF386A1B)),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Color(0xFF386A1B)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const favorite()));
            },
          ),
        ],
      ),
      // --- الـ Drawer ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF386A1B)),
              accountName: Text(user?.displayName ?? "مستخدم جديد"),
              accountEmail: Text(user?.email ?? "لا يوجد إيميل"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                child: user?.photoURL == null ? const Icon(Icons.person, size: 40, color: Color(0xFF386A1B)) : null,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text("تبديل الحساب"),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await AuthService().switchAccount();
                } catch (e) {
                  debugPrint("خطأ أثناء التبديل: $e");
                }
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.settings),
              title: const Text("الإعدادات"),
              childrenPadding: const EdgeInsets.only(right: 20),
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.language, size: 20),
                  title: Text(isEnglish ? "English" : "العربية"),
                  value: isEnglish,
                  activeThumbColor: const Color(0xFF386A1B),
                  onChanged: (bool value) { setState(() { isEnglish = value; }); },
                ),
                SwitchListTile(
                  secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, size: 20),
                  title: Text(isDarkMode ? "الوضع الليلي" : "الوضع النهاري"),
                  value: isDarkMode,
                  activeThumbColor: const Color(0xFF386A1B),
                  onChanged: (bool value) { setState(() { isDarkMode = value; }); },
                ),
              ],
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("تسجيل الخروج"),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await AuthService().signOut();
                } catch (e) {
                  debugPrint("خطأ أثناء تسجيل الخروج: $e");
                }
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/selectArea.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // إزاحة مرنة ومناسبة لتبدأ العناصر أسفل الـ AppBar مباشرة بالتناسق مع الخلفية
                SizedBox(height: screenHeight * 0.05),

                // ✂️ تم حذف حاوية زر "بحث بالفلترة" (ElevatedButton.icon) بالكامل من هنا

                _buildStepper(1),
                const SizedBox(height: 30),
                const Text(
                  "اختر مدينتك",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF386A1B),
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    children: [
                      _buildCityCard(
                          context,
                          'غزة',
                          'الرمال، النصر، تل الهوا...',
                          Icons.location_city,
                          const gaza()
                      ),
                      _buildCityCard(
                          context,
                          'الوسطى',
                          'النصيرات، دير البلح...',
                          Icons.map_outlined,
                          const AlWesta()
                      ),
                      _buildCityCard(
                          context,
                          'خانيونس',
                          'البلد، المواصي...',
                          Icons.explore_outlined,
                          const khanyonis()
                      ),
                      const SizedBox(height: 40),
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

  Widget _buildStepper(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle("3", "تأكيد", currentStep >= 3),
        _buildLine(currentStep > 2),
        _buildStepCircle("2", "المنطقة", currentStep >= 2),
        _buildLine(currentStep > 1),
        _buildStepCircle("1", "المدينة", currentStep >= 1),
      ],
    );
  }

  Widget _buildStepCircle(String step, String title, bool isActive) {
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF386A1B) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF386A1B).withOpacity(0.2)),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : null,
          ),
          child: Center(
            child: Text(step, style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
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

  Widget _buildCityCard(BuildContext context, String title, String subtitle, IconData icon, Widget targetPage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333), fontFamily: 'Cairo'),
        ),
        subtitle: Text(
          subtitle,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Cairo'),
        ),
      ),
    );
  }
}