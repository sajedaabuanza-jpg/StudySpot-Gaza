import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  ENTRY POINT
// ══════════════════════════════════════════════════════════════════════════════

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'طلب مساحة عمل',
      theme: ThemeData(
        fontFamily: 'Cairo',
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFFEFF6EF),
      ),
      home: const AddWorkspaceScreen(),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  COLORS
// ══════════════════════════════════════════════════════════════════════════════

const kGreen = Color(0xFF4CAF50);
const kGreenLight = Color(0xFFE8F5E9);
const kGreenBg = Color(0xFFEFF6EF);
const kBorder = Color(0xFFCCCCCC);
const kHint = Color(0xFFAAAAAA);
const kText = Color(0xFF333333);
const kTextSub = Color(0xFF666666);
const kWhite = Colors.white;

// ══════════════════════════════════════════════════════════════════════════════
//  REUSABLE: Section Header  (أيقونة + نص على اليمين، خلفية خضراء فاتحة)
// ══════════════════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: kGreenLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: kGreen,
            ),
          ),
          const SizedBox(width: 6),
          Icon(icon, color: kGreen, size: 17),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  REUSABLE: Input Field
// ══════════════════════════════════════════════════════════════════════════════

class _InputField extends StatelessWidget {
  final String hint;
  final IconData? leadingIcon; // على اليسار في RTL
  final int maxLines;
  final TextInputType keyboardType;

  const _InputField({
    required this.hint,
    this.leadingIcon,
    this.keyboardType = TextInputType.text,
  }) : maxLines = 1;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: TextDirection.rtl,
        hintStyle: const TextStyle(color: kHint, fontSize: 12),
        prefixIcon: leadingIcon != null
            ? Icon(leadingIcon, color: kGreen, size: 18)
            : null,
        filled: true,
        fillColor: kWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kGreen, width: 1.4),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  REUSABLE: Dropdown Field
// ══════════════════════════════════════════════════════════════════════════════

class _DropdownField extends StatefulWidget {
  final String hint;
  final List<String> items;
  final IconData? leadingIcon;
  const _DropdownField({
    required this.hint,
    required this.items,
    this.leadingIcon,
  });

  @override
  State<_DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<_DropdownField> {
  String? _val;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _val,
          isExpanded: true,
          hint: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.hint,
                  style: const TextStyle(color: kHint, fontSize: 12),
                ),
                if (widget.leadingIcon != null) ...[
                  const SizedBox(width: 5),
                  Icon(widget.leadingIcon, color: kGreen, size: 16),
                ],
              ],
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: kGreen, size: 20),
          items: widget.items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(e, style: const TextStyle(fontSize: 12)),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _val = v),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  REUSABLE: Counter  +  0  -
// ══════════════════════════════════════════════════════════════════════════════

class _Counter extends StatefulWidget {
  final String label;
  const _Counter({required this.label});
  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int _v = 0;

  Widget _btn(IconData ic, Color bg, VoidCallback fn) => GestureDetector(
    onTap: fn,
    child: Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(ic, color: kWhite, size: 15),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: kWhite,
            border: Border.all(color: kBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // + على اليسار (لأن RTL)
              _btn(Icons.add, kGreen, () => setState(() => _v++)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '$_v',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kText,
                  ),
                ),
              ),
              // - على اليمين
              _btn(
                Icons.remove,
                const Color(0xFFEF5350),
                () => setState(() {
                  if (_v > 0) _v--;
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        Text(
          widget.label,
          style: const TextStyle(fontSize: 11, color: kTextSub),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  REUSABLE: Rating Row  (label | bars | n/5)
// ══════════════════════════════════════════════════════════════════════════════

class _RatingRow extends StatelessWidget {
  final String label;
  final int filled; // 0–5
  final Color color;
  const _RatingRow({
    required this.label,
    required this.filled,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        children: [
          // n/5  على اليسار
          Text(
            '$filled/5',
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          // أشرطة
          Expanded(
            child: Row(
              children: List.generate(5, (i) {
                return Expanded(
                  child: Container(
                    height: 9,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                      color: i < filled ? color : const Color(0xFFDDDDDD),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 8),
          // label على اليمين
          SizedBox(
            width: 62,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, color: kText),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  REUSABLE: Facility Chip
// ══════════════════════════════════════════════════════════════════════════════

class _Chip extends StatefulWidget {
  final String label;
  final IconData icon;
  const _Chip({required this.label, required this.icon});
  @override
  State<_Chip> createState() => _ChipState();
}

class _ChipState extends State<_Chip> {
  bool _on = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _on = !_on),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _on ? kGreen : kWhite,
          border: Border.all(color: _on ? kGreen : kBorder),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 13, color: _on ? kWhite : kTextSub),
            const SizedBox(width: 4),
            Text(
              widget.label,
              style: TextStyle(fontSize: 11, color: _on ? kWhite : kText),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  MAIN SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class AddWorkspaceScreen extends StatefulWidget {
  const AddWorkspaceScreen({super.key});
  @override
  State<AddWorkspaceScreen> createState() => _AddWorkspaceScreenState();
}

class _AddWorkspaceScreenState extends State<AddWorkspaceScreen> {
  // ── state ──────────────────────────────────────────────────────────────────
  bool _locationSelected = false;

  // ── helpers ────────────────────────────────────────────────────────────────
  Widget _gap([double h = 10]) => SizedBox(height: h);

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: kWhite,
      border: Border.all(color: kBorder),
      borderRadius: BorderRadius.circular(8),
    ),
    child: child,
  );

  // ══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kGreenBg,
        body: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1 ── المعلومات الأساسية
                    _section1BasicInfo(),
                    _gap(),

                    // 2 ── بيانات التواصل
                    _section2Contact(),
                    _gap(),

                    // 3 ── الموقع والعنوان
                    _section3Location(),
                    _gap(),

                    // 4 ── أوقات العمل والإتاحة
                    _section4WorkHours(),
                    _gap(),

                    // 5 ── المرافق الإضافية
                    _section5Facilities(),
                    _gap(),

                    // 6 ── تقييم الخدمة الحالي
                    _section6Rating(),
                    _gap(),

                    // 7 ── الطاقة
                    _section7Capacity(),
                    _gap(),

                    // 8 ── التوزيع
                    _section8Distribution(),
                    _gap(),

                    // 9 ── صور مدخل
                    _section9Photos(),
                    _gap(),

                    // 10 ── رسالة تنبيه + زر إرسال
                    _section10Submit(),
                    _gap(20),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  APP BAR
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildAppBar() {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: top + 6, bottom: 10, left: 14, right: 14),
      color: kGreen,
      child: Row(
        children: [
          // سهم رجوع على اليمين (RTL → leading)
          const Icon(Icons.arrow_forward_ios, color: kWhite, size: 18),
          const Expanded(
            child: Text(
              'طلب إضافة مساحة عمل',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // أيقونة البيت على اليسار
          const Icon(Icons.home_outlined, color: kWhite, size: 22),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SECTION 1 – المعلومات الأساسية
  // ══════════════════════════════════════════════════════════════════════════

  Widget _section1BasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
          title: 'المعلومات الأساسية',
          icon: Icons.description_outlined,
        ),
        _gap(8),
        const _InputField(hint: 'اسم المساحة العمل باللغة العربية  *'),
        _gap(6),
        const _InputField(hint: 'اسم المساحة العمل باللغة الإنجليزية  *'),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SECTION 2 – بيانات التواصل
  // ══════════════════════════════════════════════════════════════════════════

  Widget _section2Contact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
          title: 'بيانات التواصل',
          icon: Icons.phone_outlined,
        ),
        _gap(8),
        // رقم الهاتف مع كود الدولة
        Row(
          children: [
            // حقل الرقم
            const Expanded(
              child: TextField(
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'رقم الهاتف',
                  hintStyle: TextStyle(color: kHint, fontSize: 12),
                  hintTextDirection: TextDirection.rtl,
                  filled: true,
                  fillColor: kWhite,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    borderSide: BorderSide(color: kBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    borderSide: BorderSide(color: kGreen),
                  ),
                ),
              ),
            ),
            // كود الدولة +972
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              decoration: const BoxDecoration(
                color: kGreenLight,
                border: Border(
                  top: BorderSide(color: kBorder),
                  bottom: BorderSide(color: kBorder),
                  left: BorderSide(color: kBorder),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.keyboard_arrow_down, color: kGreen, size: 16),
                  SizedBox(width: 2),
                  Text(
                    '+972',
                    style: TextStyle(
                      fontSize: 12,
                      color: kText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        _gap(6),
        // البريد الإلكتروني
        const _InputField(
          hint: 'اسم المستخدم',
          leadingIcon: Icons.alternate_email,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SECTION 3 – الموقع والعنوان
  // ══════════════════════════════════════════════════════════════════════════

  Widget _section3Location() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
          title: 'الموقع والعنوان',
          icon: Icons.location_on_outlined,
        ),
        _gap(8),
        const _DropdownField(
          hint: 'المحافظة / المنطقة',
          leadingIcon: Icons.map_outlined,
          items: [
            'رام الله والبيرة',
            'نابلس',
            'الخليل',
            'بيت لحم',
            'جنين',
            'طولكرم',
          ],
        ),
        _gap(6),
        const _DropdownField(
          hint: 'نوع العقار',
          leadingIcon: Icons.business_outlined,
          items: ['مكتب', 'شقة', 'فيلا', 'مستودع', 'أخرى'],
        ),
        _gap(6),
        const _InputField(
          hint: 'العنوان التفصيلي (المدينة، الشارع، رقم البناية)',
          leadingIcon: Icons.location_city_outlined,
        ),
        _gap(8),
        // ── زر تحديد الموقع الحالي (أخضر معبأ)
        GestureDetector(
          onTap: () => setState(() => _locationSelected = !_locationSelected),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: kGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit_location_alt_outlined, color: kWhite, size: 18),
                SizedBox(width: 6),
                Text(
                  'تحديد الموقع الحالي',
                  style: TextStyle(
                    color: kWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SECTION 4 – أوقات العمل والإتاحة
  // ══════════════════════════════════════════════════════════════════════════

  Widget _section4WorkHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
          title: 'أوقات العمل والإتاحة',
          icon: Icons.access_time_outlined,
        ),
        _gap(8),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // مثال توضيحي
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'مثال: 9:00 م إلى 11:00 م',
                    style: TextStyle(fontSize: 11, color: kTextSub),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.access_time, size: 14, color: kTextSub),
                ],
              ),
              _gap(8),
              const _InputField(hint: 'أوقات الإتاحة سبو ..'),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SECTION 5 – المرافق الإضافية
  // ══════════════════════════════════════════════════════════════════════════

  Widget _section5Facilities() {
    // صف 1: داخلي / في الهواء الطلق / مشروبات / مشاريع
    // صف 2: إضافات مياه / مطبخ / إنترنت لاسلكي / اكتب
    final row1 = [
      (Icons.chair_outlined, 'داخلي'),
      (Icons.wb_sunny_outlined, 'في الهواء الطلق'),
      (Icons.local_cafe_outlined, 'مشروبات'),
      (Icons.work_outline, 'مشاريع'),
    ];
    final row2 = [
      (Icons.water_drop_outlined, 'إضافات مياه'),
      (Icons.kitchen_outlined, 'مطبخ'),
      (Icons.wifi_outlined, 'إنترنت لاسلكي'),
      (Icons.keyboard_outlined, 'اكتب'),
    ];

    Widget chipRow(List<(IconData, String)> chips) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: chips.map((c) => _Chip(icon: c.$1, label: c.$2)).toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
          title: 'المرافق الإضافية',
          icon: Icons.star_outline,
        ),
        _gap(8),
        _card(child: Column(children: [chipRow(row1), _gap(8), chipRow(row2)])),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SECTION 6 – تقييم الخدمة الحالي
  // ══════════════════════════════════════════════════════════════════════════

  Widget _section6Rating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
          title: 'تقييم الخدمة الحالي',
          icon: Icons.bar_chart,
        ),
        _gap(8),
        _card(
          child: Column(
            children: const [
              _RatingRow(
                label: 'الإنترنت',
                filled: 4,
                color: Color(0xFF4CAF50),
              ),
              _RatingRow(label: 'الأمان', filled: 3, color: Color(0xFF2196F3)),
              _RatingRow(
                label: 'التجهيزات',
                filled: 5,
                color: Color(0xFFFF9800),
              ),
              _RatingRow(label: 'الهدوء', filled: 3, color: Color(0xFF9C27B0)),
              _RatingRow(label: 'الأسعار', filled: 4, color: Color(0xFFE91E63)),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SECTION 7 – الطاقة
  // ══════════════════════════════════════════════════════════════════════════

  Widget _section7Capacity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'الطاقة', icon: Icons.people_outline),
        _gap(8),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // اسم مدير الطاقة
              const _InputField(
                hint: 'اسم مدير الطاقة (الشخص المسؤول)',
                leadingIcon: Icons.person_outline,
              ),
              _gap(10),
              // صف: صور الأشخاص/الأماكن + dropdown "ساعة"
              Row(
                children: [
                  // dropdown ساعة
                  Expanded(
                    child: _DropdownField(
                      hint: 'ساعة',
                      items: const ['ساعة', 'يوم', 'أسبوع', 'شهر'],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'صور مدخل الأشخاص/الأماكن',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 11, color: kTextSub),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SECTION 8 – التوزيع  (4 عدادات + 0 -)
  // ══════════════════════════════════════════════════════════════════════════

  Widget _section8Distribution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // رأس القسم مع أيقونة + خضراء
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'التوزيع',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: kGreen,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: kGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: kWhite, size: 14),
            ),
          ],
        ),
        _gap(8),
        _card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _Counter(label: 'ساعة'),
              _Counter(label: 'يوم'),
              _Counter(label: 'أسبوع'),
              _Counter(label: 'شهر'),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SECTION 9 – صور مدخل الطلب / مدة التمديد
  // ══════════════════════════════════════════════════════════════════════════

  Widget _section9Photos() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // السطر العلوي: "صور مدخل الطلب" + أيقونة صورة
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'صور مدخل الطلب',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: kText,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.add_a_photo_outlined, color: kGreen, size: 17),
            ],
          ),
          _gap(8),
          // نص "السماح بالتمديد من الطلب (أسبو - 1 أسبو ...)"
          const Text(
            'السماح بالتمديد من الطلب (أسبو - ١ أسبو ...)',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 11, color: kTextSub),
          ),
          _gap(8),
          // صف عدادات التمديد: + + + +
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (_) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: kWhite,
                  border: Border.all(color: kBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '+',
                  style: TextStyle(
                    fontSize: 18,
                    color: kGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SECTION 10 – رسالة التنبيه + زر الإرسال
  // ══════════════════════════════════════════════════════════════════════════

  Widget _section10Submit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // رسالة التنبيه الصفراء
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9C4),
            border: Border.all(color: const Color(0xFFFFEE58)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'عزيزتي/ي سيقوم فريق إدارة المنصة بمراجعة طلبك والتواصل معك في أقرب وقت ممكن. شكراً لتسجيلك في المنصة.',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF555500),
              height: 1.55,
            ),
          ),
        ),
        _gap(12),
        // زر إرسال الطلب
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'تم إرسال الطلب بنجاح ✓',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: kGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: kGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send, color: kWhite, size: 18),
                SizedBox(width: 8),
                Text(
                  'إرسال الطلب',
                  style: TextStyle(
                    color: kWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  BOTTOM NAV  (4 أيقونات فقط بدون نص)
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildBottomNav() {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: bottom + 8,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: kWhite,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home_outlined, color: kTextSub, size: 26),
          Icon(Icons.search_outlined, color: kTextSub, size: 26),
          // أيقونة الإضافة – مميزة بدائرة خضراء
          _AddNavIcon(),
          Icon(Icons.person_outline, color: kTextSub, size: 26),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  أيقونة الإضافة في الـ Bottom Nav (دائرة خضراء)
// ══════════════════════════════════════════════════════════════════════════════

class _AddNavIcon extends StatelessWidget {
  const _AddNavIcon();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(color: kGreen, shape: BoxShape.circle),
      child: const Icon(Icons.add, color: kWhite, size: 26),
    );
  }
}
