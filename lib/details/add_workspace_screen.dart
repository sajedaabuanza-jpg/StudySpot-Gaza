import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  ثيم المشروع - الألوان الرسمية من StudySpot Gaza
// ══════════════════════════════════════════════════════════════════════════════

const kGreen      = Color(0xFF386A1B);
const kGreenLight = Color(0xFFF1F8E9);
const kGreenBg    = Color(0xFFEFF6EF);
const kBorder     = Color(0xFFCCCCCC);
const kHint       = Color(0xFFAAAAAA);
const kText       = Color(0xFF333333);
const kTextSub    = Color(0xFF666666);
const kWhite      = Colors.white;

// ══════════════════════════════════════════════════════════════════════════════
//  قائمة المناطق المطابقة لقيم district في Firestore
//  (يجب أن تطابق isEqualTo في صفحات المناطق 100%)
// ══════════════════════════════════════════════════════════════════════════════

// غزة
const List<String> _gazaDistricts = [
  'النصر', 'التفاح', 'الرمال', 'تل الهوى', 'شمال غزة', 'الشاطئ',
];
// الوسطى
const List<String> _westaDistricts = [
  'دير البلح', 'النصيرات', 'البريج', 'المغازي', 'الزوايدة',
];
// خانيونس
const List<String> _khanDistricts = [
  'البلد', 'مدينة حمد والقرارة', 'المواصي',
];

// ══════════════════════════════════════════════════════════════════════════════
//  REUSABLE: Section Header
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
  final TextEditingController? controller;

  const _InputField({
    required this.hint,
    this.leadingIcon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
  final ValueChanged<String?>? onChanged;
  final String? initialValue;

  const _DropdownField({
    required this.hint,
    required this.items,
    this.leadingIcon,
    this.onChanged,
    this.initialValue,
  });

  @override
  State<_DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<_DropdownField> {
  String? _val;

  @override
  void initState() {
    super.initState();
    _val = widget.initialValue;
  }

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
          onChanged: (v) {
            setState(() => _val = v);
            widget.onChanged?.call(v);
          },
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  REUSABLE: Counter
// ══════════════════════════════════════════════════════════════════════════════

class _Counter extends StatefulWidget {
  final String label;
  final ValueNotifier<int>? notifier;
  const _Counter({required this.label, this.notifier});

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
              _btn(Icons.add, kGreen, () {
                setState(() => _v++);
                widget.notifier?.value = _v;
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('$_v',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold, color: kText)),
              ),
              _btn(Icons.remove, const Color(0xFFEF5350), () {
                setState(() {
                  if (_v > 0) _v--;
                });
                widget.notifier?.value = _v;
              }),
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

class _RatingRow extends StatefulWidget {
  final String label;
  final int filled;
  final Color color;
  final ValueChanged<int>? onChanged;

  const _RatingRow({
    required this.label,
    required this.filled,
    required this.color,
    this.onChanged,
  });

  @override
  State<_RatingRow> createState() => _RatingRowState();
}

class _RatingRowState extends State<_RatingRow> {
  late int _filled;

  @override
  void initState() {
    super.initState();
    _filled = widget.filled;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        children: [
          Text('$_filled/5',
              style: TextStyle(
                  fontSize: 11, color: widget.color, fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Expanded(
            child: Row(
              children: List.generate(5, (i) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _filled = i + 1);
                      widget.onChanged?.call(i + 1);
                    },
                    child: Container(
                      height: 9,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      decoration: BoxDecoration(
                        color: i < _filled ? widget.color : const Color(0xFFDDDDDD),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 62,
            child: Text(widget.label,
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
  final String value;
  final ValueChanged<bool>? onToggle;

  const _Chip({
    required this.label,
    required this.icon,
    required this.value,
    this.onToggle,
  });

  @override
  State<_Chip> createState() => _ChipState();
}

class _ChipState extends State<_Chip> {
  bool _on = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _on = !_on);
        widget.onToggle?.call(_on);
      },
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
  bool _isLoading = false;

  // ── Controllers ───────────────────────────────────────────────────────────
  final _nameArController       = TextEditingController();
  final _nameEnController       = TextEditingController();
  final _phoneController        = TextEditingController();
  final _emailController        = TextEditingController();
  final _detailAddressController = TextEditingController();
  final _workHoursController    = TextEditingController();
  final _managerController      = TextEditingController();
  final _imageUrlController     = TextEditingController();
  final _descriptionController  = TextEditingController();
  final _pricingPlansController = TextEditingController();
  final _locationUrlController  = TextEditingController();

  // ── Dropdowns ─────────────────────────────────────────────────────────────
  String? _selectedGovernorate;
  String? _selectedDistrict;
  String? _selectedType;
  String? _selectedPricingSystem;

  List<String> _availableDistricts = [];

  // ── Filters (filters_csv) ─────────────────────────────────────────────────
  final Set<String> _selectedFilters = {};

  // ── Quality Scores ────────────────────────────────────────────────────────
  int _ratingInternet     = 4;
  int _ratingSecurity     = 3;
  int _ratingEquipment    = 5;
  int _ratingQuiet        = 3;
  int _ratingPrice        = 4;

  // ── Counters ──────────────────────────────────────────────────────────────
  final _seatsSingle = ValueNotifier<int>(0);
  final _seatsPair   = ValueNotifier<int>(0);
  final _seatsGroup  = ValueNotifier<int>(0);
  final _seatsHall   = ValueNotifier<int>(0);

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _detailAddressController.dispose();
    _workHoursController.dispose();
    _managerController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    _pricingPlansController.dispose();
    _locationUrlController.dispose();
    _seatsSingle.dispose();
    _seatsPair.dispose();
    _seatsGroup.dispose();
    _seatsHall.dispose();
    super.dispose();
  }

  void _onGovernorateChanged(String? gov) {
    setState(() {
      _selectedGovernorate = gov;
      _selectedDistrict = null;
      if (gov == 'غزة') {
        _availableDistricts = _gazaDistricts;
      } else if (gov == 'الوسطى') {
        _availableDistricts = _westaDistricts;
      } else if (gov == 'خانيونس') {
        _availableDistricts = _khanDistricts;
      } else {
        _availableDistricts = [];
      }
    });
  }

  Future<void> _addWorkspace() async {
    if (_nameArController.text.trim().isEmpty) {
      _showError('يرجى إدخال اسم المساحة بالعربية');
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showError('يرجى إدخال رقم الهاتف');
      return;
    }
    if (_selectedGovernorate == null) {
      _showError('يرجى اختيار المحافظة');
      return;
    }
    if (_selectedDistrict == null) {
      _showError('يرجى اختيار المنطقة');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final qualityScores =
          'internet:$_ratingInternet'
          '|stability:$_ratingSecurity'
          '|electricity:$_ratingEquipment'
          '|environment:$_ratingQuiet';

      final filtersCsv = _selectedFilters.join(',');

      String pricingPlans = _pricingPlansController.text.trim();
      if (pricingPlans.isEmpty) {
        final system = _selectedPricingSystem ?? 'بالساعة';
        pricingPlans = 'سعر $system=يرجى الاستفسار';
      }

      final double avgRating =
          (_ratingInternet + _ratingSecurity + _ratingEquipment + _ratingQuiet) / 4.0;

      final hasElectricity = _selectedFilters.contains('electricity');
      final hasInternet    = _selectedFilters.contains('internet');

      final electricityDetails = hasElectricity
          ? 'كهرباء متوفرة في المكان'
          : 'يرجى الاستفسار عن توفر الكهرباء';
      final internetDetails = hasInternet
          ? 'واي فاي سريع ومتوفر'
          : 'يرجى الاستفسار عن الإنترنت';

      final workspaceData = <String, dynamic>{
        'name'                : _nameArController.text.trim(),
        'name_en'             : _nameEnController.text.trim().isEmpty
            ? _nameArController.text.trim()
            : _nameEnController.text.trim(),
        'description'         : _descriptionController.text.trim().isEmpty
            ? 'مساحة عمل متاحة للدراسة والعمل'
            : _descriptionController.text.trim(),
        'city'                : _selectedGovernorate ?? '',
        'district'            : _selectedDistrict ?? '',
        'location'            : _detailAddressController.text.trim(),
        'phone'               : _phoneController.text.trim(),
        'image_url'           : _imageUrlController.text.trim(),
        'pricing_plans'       : pricingPlans,
        'filters_csv'         : filtersCsv,
        'quality_scores'      : qualityScores,
        'working_hours'       : _workHoursController.text.trim().isEmpty
            ? 'غير محدد'
            : _workHoursController.text.trim(),
        'rating'              : avgRating,
        'electricity_details' : electricityDetails,
        'internet_details'    : internetDetails,
        'nearest_landmark'    : _detailAddressController.text.trim().isEmpty
            ? _selectedDistrict ?? ''
            : _detailAddressController.text.trim(),
        'location_url'        : _locationUrlController.text.trim(),
        'avgRating'           : avgRating,
        'totalReviews'        : 0,
        'barFractions'        : [0.0, 0.0, 0.0, 0.0, 0.0],
        'amenities'           : _selectedFilters.toList(),
        'price_per_hour'      : _selectedPricingSystem ?? 'بالساعة',
        'latitude'            : 0.0,
        'longitude'           : 0.0,
        'seats_single'        : _seatsSingle.value,
        'seats_pair'          : _seatsPair.value,
        'seats_group'         : _seatsGroup.value,
        'seats_hall'          : _seatsHall.value,
        'total_seats'         : _seatsSingle.value
            + _seatsPair.value * 2
            + _seatsGroup.value * 4
            + _seatsHall.value * 10,
        'manager'             : _managerController.text.trim(),
        'email'               : _emailController.text.trim(),
        'workspace_type'      : _selectedType ?? 'مساحة عمل',
        'createdAt'           : FieldValue.serverTimestamp(),
        'status'              : 'pending',
        'verified'            : false,
      };

      await FirebaseFirestore.instance
          .collection('workspaces')
          .add(workspaceData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'تم إرسال الطلب بنجاح ✓',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
            ),
            backgroundColor: kGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showError('حدث خطأ أثناء الحفظ: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

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
        appBar: AppBar(
          backgroundColor: kGreen,
          elevation: 0,
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
        _InputField(hint: 'اسم المساحة باللغة العربية  *', controller: _nameArController),
        _gap(6),
        _InputField(hint: 'اسم المساحة باللغة الإنجليزية  *', controller: _nameEnController),
        _gap(6),
        _InputField(
          hint: 'وصف مختصر للمساحة',
          controller: _descriptionController,
          maxLines: 2,
        ),
        _gap(6),
        _InputField(
          hint: 'رابط صورة المساحة (image_url)',
          controller: _imageUrlController,
          leadingIcon: Icons.image_outlined,
          keyboardType: TextInputType.url,
        ),
        _gap(6),
        _InputField(
          hint: 'خطط الأسعار  مثال: اشتراك شهري=150₪|يومي=10₪',
          controller: _pricingPlansController,
          leadingIcon: Icons.payments_outlined,
        ),
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
            Expanded(
              child: TextField(
                controller: _phoneController,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'رقم الهاتف',
                  hintStyle: TextStyle(color: kHint, fontSize: 12, fontFamily: 'Cairo'),
                  hintTextDirection: TextDirection.rtl,
                  filled: true,
                  fillColor: kWhite,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
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
        _InputField(
          hint: 'البريد الإلكتروني أو اسم المستخدم',
          leadingIcon: Icons.alternate_email,
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
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
        _DropdownField(
          hint: 'المحافظة / المنطقة',
          leadingIcon: Icons.map_outlined,
          items: const ['غزة', 'الوسطى', 'خانيونس'],
          onChanged: _onGovernorateChanged,
        ),
        _gap(6),
        _DropdownField(
          hint: 'المنطقة (الحي)',
          leadingIcon: Icons.location_city_outlined,
          items: _availableDistricts.isEmpty
              ? ['اختر المحافظة أولاً']
              : _availableDistricts,
          onChanged: (v) {
            if (v != 'اختر المحافظة أولاً') {
              _selectedDistrict = v;
            }
          },
        ),
        _gap(6),
        _DropdownField(
          hint: 'نوع المساحة',
          leadingIcon: Icons.business_outlined,
          items: const ['مقهى', 'مكتبة', 'مركز دراسي', 'مساحة مشتركة', 'أخرى'],
          onChanged: (v) => _selectedType = v,
        ),
        _gap(6),
        _InputField(
          hint: 'العنوان التفصيلي (المدينة، الشارع، رقم البناية)',
          leadingIcon: Icons.location_city_outlined,
          controller: _detailAddressController,
        ),
        _gap(6),
        _InputField(
          hint: 'رابط الموقع على الخريطة (Google Maps)',
          leadingIcon: Icons.map_outlined,
          controller: _locationUrlController,
          keyboardType: TextInputType.url,
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
              _InputField(
                hint: 'أوقات الإتاحة (الأيام والساعات)..',
                controller: _workHoursController,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── SECTION 5: المرافق الإضافية ────────────────────────────────────────────
  Widget _section5Facilities() {
    final row1 = [
      (Icons.flash_on,            'كهرباء',         'electricity'),
      (Icons.wifi_outlined,       'واي فاي',        'internet'),
      (Icons.local_cafe_outlined, 'مشروبات',        'drinks'),
      (Icons.directions_bus,      'مواصلات',        'transport'),
    ];
    final row2 = [
      (Icons.wc,                  'دورات مياه',     'wc'),
      (Icons.print_outlined,      'طباعة',          'print'),
      (Icons.wb_sunny_outlined,   'في الهواء الطلق','outdoor'),
      (Icons.keyboard_outlined,   'مكاتب',          'desks'),
    ];

    Widget chipRow(List<(IconData, String, String)> chips) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: chips
          .map((c) => _Chip(
        icon: c.$1,
        label: c.$2,
        value: c.$3,
        onToggle: (isOn) {
          setState(() {
            if (isOn) {
              _selectedFilters.add(c.$3);
            } else {
              _selectedFilters.remove(c.$3);
            }
          });
        },
      ))
          .toList(),
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
          child: Column(
            children: [
              _RatingRow(
                label: 'الإنترنت',
                filled: _ratingInternet,
                color: const Color(0xFF386A1B),
                onChanged: (v) => setState(() => _ratingInternet = v),
              ),
              _RatingRow(
                label: 'الأمان',
                filled: _ratingSecurity,
                color: const Color(0xFF2196F3),
                onChanged: (v) => setState(() => _ratingSecurity = v),
              ),
              _RatingRow(
                label: 'التجهيزات',
                filled: _ratingEquipment,
                color: const Color(0xFFFF9800),
                onChanged: (v) => setState(() => _ratingEquipment = v),
              ),
              _RatingRow(
                label: 'الهدوء',
                filled: _ratingQuiet,
                color: const Color(0xFF9C27B0),
                onChanged: (v) => setState(() => _ratingQuiet = v),
              ),
              _RatingRow(
                label: 'الأسعار',
                filled: _ratingPrice,
                color: const Color(0xFFE91E63),
                onChanged: (v) => setState(() => _ratingPrice = v),
              ),
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
              _InputField(
                hint: 'اسم المسؤول عن المساحة',
                leadingIcon: Icons.person_outline,
                controller: _managerController,
              ),
              _gap(10),
              Row(
                children: [
                  Expanded(
                    child: _DropdownField(
                      hint: 'تسعيرة الإيجار',
                      items: const ['بالساعة', 'باليوم', 'بالأسبوع', 'بالشهر'],
                      onChanged: (v) => _selectedPricingSystem = v,
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
              decoration: const BoxDecoration(color: kGreen, shape: BoxShape.circle),
              child: const Icon(Icons.event_seat, color: kWhite, size: 14),
            ),
          ],
        ),
        _gap(8),
        _card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Counter(label: 'فردي',   notifier: _seatsSingle),
              _Counter(label: 'ثنائي',  notifier: _seatsPair),
              _Counter(label: 'مجموعة', notifier: _seatsGroup),
              _Counter(label: 'قاعة',   notifier: _seatsHall),
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
        SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _addWorkspace,
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            child: _isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: kWhite, strokeWidth: 2),
            )
                : const Row(
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