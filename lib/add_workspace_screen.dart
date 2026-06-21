import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  ثيم المشروع - الألوان الرسمية من StudySpot Gaza
// ══════════════════════════════════════════════════════════════════════════════

const kGreen       = Color(0xFF386A1B); // اللون الرئيسي للمشروع
const kGreenLight  = Color(0xFFF1F8E9); // خلفية الأقسام الخضراء الفاتحة
const kGreenBg     = Color(0xFFEFF6EF); // خلفية الشاشة
const kBorder      = Color(0xFFCCCCCC);
const kHint        = Color(0xFFAAAAAA);
const kText        = Color(0xFF333333);
const kTextSub     = Color(0xFF666666);
const kWhite       = Colors.white;

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
              fontFamily: 'Cairo',
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
  final IconData? leadingIcon;
  final int maxLines;
  final TextInputType keyboardType;

  const _InputField({
    required this.hint,
    this.leadingIcon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: TextDirection.rtl,
        hintStyle: const TextStyle(color: kHint, fontSize: 12, fontFamily: 'Cairo'),
        prefixIcon: leadingIcon != null
            ? Icon(leadingIcon, color: kGreen, size: 18)
            : null,
        filled: true,
        fillColor: kWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
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
  const _DropdownField({required this.hint, required this.items, this.leadingIcon});

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
                Text(widget.hint,
                    style: const TextStyle(color: kHint, fontSize: 12, fontFamily: 'Cairo')),
                if (widget.leadingIcon != null) ...[
                  const SizedBox(width: 5),
                  Icon(widget.leadingIcon, color: kGreen, size: 16),
                ],
              ],
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: kGreen, size: 20),
          items: widget.items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(e,
                          style: const TextStyle(fontSize: 12, fontFamily: 'Cairo')),
                    ),
                  ))
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
              _btn(Icons.add, kGreen, () => setState(() => _v++)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('$_v',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold, color: kText)),
              ),
              _btn(Icons.remove, const Color(0xFFEF5350),
                  () => setState(() { if (_v > 0) _v--; })),
            ],
          ),
        ),
        const SizedBox(height: 3),
        Text(widget.label,
            style: const TextStyle(fontSize: 11, color: kTextSub, fontFamily: 'Cairo')),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  REUSABLE: Rating Row
// ══════════════════════════════════════════════════════════════════════════════

class _RatingRow extends StatelessWidget {
  final String label;
  final int filled;
  final Color color;
  const _RatingRow({required this.label, required this.filled, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        children: [
          Text('$filled/5',
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
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
          SizedBox(
            width: 62,
            child: Text(label,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 12, color: kText, fontFamily: 'Cairo')),
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
            Text(widget.label,
                style: TextStyle(
                    fontSize: 11,
                    color: _on ? kWhite : kText,
                    fontFamily: 'Cairo')),
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
  bool _locationSelected = false;

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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kGreenBg,
        // ✅ AppBar بنفس أسلوب المشروع
        appBar: AppBar(
          backgroundColor: kGreen,
          elevation: 0,
          // زر الرجوع التلقائي (يعمل مع Navigator.pop تلقائياً)
          iconTheme: const IconThemeData(color: kWhite),
          title: const Text(
            'طلب إضافة مساحة عمل',
            style: TextStyle(
              color: kWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.home_outlined, color: kWhite),
              onPressed: () {
                // الرجوع لصفحة المدن (city) مع مسح الـ stack
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _section1BasicInfo(),
              _gap(),
              _section2Contact(),
              _gap(),
              _section3Location(),
              _gap(),
              _section4WorkHours(),
              _gap(),
              _section5Facilities(),
              _gap(),
              _section6Rating(),
              _gap(),
              _section7Capacity(),
              _gap(),
              _section8Distribution(),
              _gap(),
              _section9Photos(),
              _gap(),
              _section10Submit(),
              _gap(30),
            ],
          ),
        ),
      ),
    );
  }

  // ── SECTION 1: المعلومات الأساسية ──────────────────────────────────────────
  Widget _section1BasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'المعلومات الأساسية', icon: Icons.description_outlined),
        _gap(8),
        const _InputField(hint: 'اسم المساحة باللغة العربية  *'),
        _gap(6),
        const _InputField(hint: 'اسم المساحة باللغة الإنجليزية  *'),
      ],
    );
  }

  // ── SECTION 2: بيانات التواصل ──────────────────────────────────────────────
  Widget _section2Contact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'بيانات التواصل', icon: Icons.phone_outlined),
        _gap(8),
        Row(
          children: [
            const Expanded(
              child: TextField(
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.phone,
                style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'رقم الهاتف',
                  hintStyle: TextStyle(color: kHint, fontSize: 12, fontFamily: 'Cairo'),
                  hintTextDirection: TextDirection.rtl,
                  filled: true,
                  fillColor: kWhite,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 11),
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
                  Text('+970',
                      style: TextStyle(
                          fontSize: 12,
                          color: kText,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo')),
                ],
              ),
            ),
          ],
        ),
        _gap(6),
        const _InputField(
          hint: 'البريد الإلكتروني أو اسم المستخدم',
          leadingIcon: Icons.alternate_email,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  // ── SECTION 3: الموقع والعنوان ─────────────────────────────────────────────
  Widget _section3Location() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'الموقع والعنوان', icon: Icons.location_on_outlined),
        _gap(8),
        // ✅ نفس المدن الموجودة في city.dart
        const _DropdownField(
          hint: 'المحافظة / المنطقة',
          leadingIcon: Icons.map_outlined,
          items: ['غزة', 'الوسطى', 'خانيونس'],
        ),
        _gap(6),
        const _DropdownField(
          hint: 'نوع المساحة',
          leadingIcon: Icons.business_outlined,
          items: ['مقهى', 'مكتبة', 'مركز دراسي', 'مساحة مشتركة', 'أخرى'],
        ),
        _gap(6),
        const _InputField(
          hint: 'العنوان التفصيلي (المدينة، الشارع، رقم البناية)',
          leadingIcon: Icons.location_city_outlined,
        ),
        _gap(8),
        GestureDetector(
          onTap: () => setState(() => _locationSelected = !_locationSelected),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: _locationSelected ? const Color(0xFF2E5815) : kGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _locationSelected
                      ? Icons.check_circle_outline
                      : Icons.edit_location_alt_outlined,
                  color: kWhite,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  _locationSelected ? 'تم تحديد الموقع ✓' : 'تحديد الموقع الحالي',
                  style: const TextStyle(
                      color: kWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── SECTION 4: أوقات العمل ─────────────────────────────────────────────────
  Widget _section4WorkHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
            title: 'أوقات العمل والإتاحة', icon: Icons.access_time_outlined),
        _gap(8),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('مثال: السبت–الخميس من 8:00 ص إلى 11:00 م',
                      style: TextStyle(
                          fontSize: 11, color: kTextSub, fontFamily: 'Cairo')),
                  SizedBox(width: 5),
                  Icon(Icons.access_time, size: 14, color: kTextSub),
                ],
              ),
              _gap(8),
              const _InputField(hint: 'أوقات الإتاحة (الأيام والساعات)..'),
            ],
          ),
        ),
      ],
    );
  }

  // ── SECTION 5: المرافق الإضافية ────────────────────────────────────────────
  Widget _section5Facilities() {
    // ✅ نفس الفلاتر الموجودة في filter_page.dart
    final row1 = [
      (Icons.flash_on, 'كهرباء'),
      (Icons.wifi_outlined, 'واي فاي'),
      (Icons.local_cafe_outlined, 'مشروبات'),
      (Icons.directions_bus, 'مواصلات'),
    ];
    final row2 = [
      (Icons.wc, 'دورات مياه'),
      (Icons.kitchen_outlined, 'مطبخ'),
      (Icons.wb_sunny_outlined, 'في الهواء الطلق'),
      (Icons.keyboard_outlined, 'مكاتب'),
    ];

    Widget chipRow(List<(IconData, String)> chips) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: chips.map((c) => _Chip(icon: c.$1, label: c.$2)).toList(),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'المرافق والخدمات', icon: Icons.star_outline),
        _gap(8),
        _card(child: Column(children: [chipRow(row1), _gap(8), chipRow(row2)])),
      ],
    );
  }

  // ── SECTION 6: تقييم الخدمة ────────────────────────────────────────────────
  Widget _section6Rating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'تقييم الخدمة الحالي', icon: Icons.bar_chart),
        _gap(8),
        _card(
          child: const Column(
            children: [
              _RatingRow(label: 'الإنترنت',   filled: 4, color: Color(0xFF386A1B)),
              _RatingRow(label: 'الأمان',     filled: 3, color: Color(0xFF2196F3)),
              _RatingRow(label: 'التجهيزات',  filled: 5, color: Color(0xFFFF9800)),
              _RatingRow(label: 'الهدوء',     filled: 3, color: Color(0xFF9C27B0)),
              _RatingRow(label: 'الأسعار',    filled: 4, color: Color(0xFFE91E63)),
            ],
          ),
        ),
      ],
    );
  }

  // ── SECTION 7: الطاقة الاستيعابية ─────────────────────────────────────────
  Widget _section7Capacity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'الطاقة الاستيعابية', icon: Icons.people_outline),
        _gap(8),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const _InputField(
                hint: 'اسم المسؤول عن المساحة',
                leadingIcon: Icons.person_outline,
              ),
              _gap(10),
              Row(
                children: [
                  Expanded(
                    child: _DropdownField(
                      hint: 'تسعيرة الإيجار',
                      items: const ['بالساعة', 'باليوم', 'بالأسبوع', 'بالشهر'],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'نظام التسعير المعتمد',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 11, color: kTextSub, fontFamily: 'Cairo'),
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

  // ── SECTION 8: التوزيع ─────────────────────────────────────────────────────
  Widget _section8Distribution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('عدد المقاعد المتاحة',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: kGreen,
                    fontFamily: 'Cairo')),
            const SizedBox(width: 6),
            Container(
              width: 22,
              height: 22,
              decoration:
                  const BoxDecoration(color: kGreen, shape: BoxShape.circle),
              child: const Icon(Icons.event_seat, color: kWhite, size: 14),
            ),
          ],
        ),
        _gap(8),
        _card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _Counter(label: 'فردي'),
              _Counter(label: 'ثنائي'),
              _Counter(label: 'مجموعة'),
              _Counter(label: 'قاعة'),
            ],
          ),
        ),
      ],
    );
  }

  // ── SECTION 9: الصور ───────────────────────────────────────────────────────
  Widget _section9Photos() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('صور المساحة',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: kText,
                      fontFamily: 'Cairo')),
              SizedBox(width: 5),
              Icon(Icons.add_a_photo_outlined, color: kGreen, size: 17),
            ],
          ),
          _gap(8),
          const Text(
            'أضف صوراً واضحة للمدخل، القاعات، والمرافق (حد أقصى 5 صور)',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 11, color: kTextSub, fontFamily: 'Cairo'),
          ),
          _gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (_) => Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: kGreenLight,
                  border: Border.all(color: const Color(0xFF6A994E)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_photo_alternate_outlined,
                    size: 28, color: kGreen),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── SECTION 10: الإرسال ────────────────────────────────────────────────────
  Widget _section10Submit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // رسالة تنبيه بألوان تتناسب مع الثيم
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F8E9),
            border: Border.all(color: const Color(0xFF6A994E).withOpacity(0.4)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'سيقوم فريق StudySpot بمراجعة طلبك والتواصل معك في أقرب وقت. شكراً لمساهمتك في دعم مجتمع الدراسة.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF386A1B),
                      height: 1.6,
                      fontFamily: 'Cairo'),
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.info_outline, color: Color(0xFF6A994E), size: 18),
            ],
          ),
        ),
        _gap(14),
        // ✅ زر الإرسال بنفس أسلوب أزرار المشروع
        SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'تم إرسال الطلب بنجاح ✓',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                  ),
                  backgroundColor: kGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send, color: kWhite, size: 20),
                SizedBox(width: 10),
                Text(
                  'إرسال الطلب',
                  style: TextStyle(
                      color: kWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
