import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
    CircleAvatar,
    Colors,
    Icons,
    CustomPainter,
    CustomPaint,
    Canvas,
    Paint,
    Path,
    Offset,
    BoxShadow,
    BoxDecoration,
    BorderRadius,
    Border,
    Material;

import 'package:cloud_firestore/cloud_firestore.dart';

const _darkGreen = Color(0xFF2D5A00);
const _lightGreenBg = Color(0xFFEFF6E0);
const _cardWhite = Color(0xFFFAFAF5);
const _starGold = Color(0xFFFFC107);
const _starEmpty = Color(0xFFD4D4D4);
const _textDark = Color(0xFF1A1A1A);
const _ratingGreen = Color(0xFF3A7D00);

class CafeRatingInfo {
  final double avgRating;
  final int totalReviews;
  final List<double> barFractions;

  const CafeRatingInfo({
    required this.avgRating,
    required this.totalReviews,
    required this.barFractions,
  });
}

class ReviewModel {
  final String id;
  final String userName;
  final String avatarLabel;
  final Color avatarColor;
  final int rating;
  final String date;
  final String comment;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.avatarLabel,
    required this.avatarColor,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

class RatingsService {
  static final _db = FirebaseFirestore.instance;

  static Future<CafeRatingInfo> fetchCafeRating(String cafeId) async {
    try {
      final doc = await _db.collection('workspaces').doc(cafeId).get();
      if (!doc.exists || doc.data() == null) {
        return const CafeRatingInfo(
          avgRating: 0.0,
          totalReviews: 0,
          barFractions: [0, 0, 0, 0, 0],
        );
      }
      final data = doc.data()!;
      return CafeRatingInfo(
        avgRating: (data['avgRating'] as num?)?.toDouble() ?? 0.0,
        totalReviews: (data['totalReviews'] as num?)?.toInt() ?? 0,
        barFractions: data['barFractions'] != null
            ? List<double>.from(data['barFractions'])
            : [0, 0, 0, 0, 0],
      );
    } catch (_) {
      return const CafeRatingInfo(
        avgRating: 0.0,
        totalReviews: 0,
        barFractions: [0, 0, 0, 0, 0],
      );
    }
  }

  static Future<List<ReviewModel>> fetchReviews(String cafeId) async {
    try {
      final snap = await _db
          .collection('workspaces')
          .doc(cafeId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();

      if (snap.docs.isEmpty) return [];

      final avatarColors = [
        const Color(0xFFF5A623),
        const Color(0xFF4CAF50),
        const Color(0xFF2196F3),
        const Color(0xFF9C27B0),
        const Color(0xFFE91E63),
      ];

      return snap.docs.asMap().entries.map((entry) {
        final i = entry.key;
        final doc = entry.value;
        final data = doc.data();
        final name = data['userName'] as String? ?? 'مجهول';
        return ReviewModel(
          id: doc.id,
          userName: name,
          avatarLabel: name.isNotEmpty ? name[0] : '؟',
          avatarColor: avatarColors[i % avatarColors.length],
          rating: (data['rating'] as num?)?.toInt() ?? 0,
          date: data['createdAt'] != null
              ? _formatDate((data['createdAt'] as Timestamp).toDate())
              : '',
          comment: data['comment'] as String? ?? '',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> submitReview({
    required String cafeId,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
  }) async {
    final cafeRef = _db.collection('workspaces').doc(cafeId);
    final cafeSnap = await cafeRef.get();
    final data = cafeSnap.data() as Map<String, dynamic>? ?? {};

    final currentTotal = (data['totalReviews'] as num?)?.toInt() ?? 0;
    final currentAvg = (data['avgRating'] as num?)?.toDouble() ?? 0.0;
    final newTotal = currentTotal + 1;
    final newAvg = ((currentAvg * currentTotal) + rating) / newTotal;

    final currentFractions = List<double>.from(
      data['barFractions'] ?? [0.0, 0.0, 0.0, 0.0, 0.0],
    );
    final currentCounts =
    currentFractions.map((f) => (f * currentTotal).round()).toList();
    currentCounts[rating - 1] += 1;
    final newFractions = currentCounts
        .map((c) => newTotal > 0 ? c / newTotal : 0.0)
        .toList();

    await cafeRef.set({
      'avgRating': newAvg,
      'totalReviews': newTotal,
      'barFractions': newFractions,
    }, SetOptions(merge: true));

    await cafeRef.collection('reviews').doc().set({
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static String _formatDate(DateTime date) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${months[date.month - 1]} ${date.day} ${date.year}';
  }
}

class RatingsScreen extends StatefulWidget {
  final String cafeId;
  final String cafeName;

  const RatingsScreen({
    super.key,
    required this.cafeId,
    required this.cafeName,
  });

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  CafeRatingInfo? _ratingInfo;
  List<ReviewModel> _reviews = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      RatingsService.fetchCafeRating(widget.cafeId),
      RatingsService.fetchReviews(widget.cafeId),
    ]);
    if (!mounted) return;
    setState(() {
      _ratingInfo = results[0] as CafeRatingInfo;
      _reviews = results[1] as List<ReviewModel>;
      _loading = false;
    });
  }

  void _openAddReview() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => AddReviewSheet(
        cafeId: widget.cafeId,
        onSubmitted: _load,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.transparent,
        child: CupertinoPageScaffold(
          backgroundColor: _darkGreen,
          child: Stack(
            children: [
              const _WaveBackground(),
              SafeArea(
                child: Column(
                  children: [
                    _AppBar(cafeName: widget.cafeName),
                    Expanded(
                      child: _loading
                          ? const Center(
                        child: CupertinoActivityIndicator(
                          color: CupertinoColors.white,
                          radius: 16,
                        ),
                      )
                          : _Body(
                        ratingInfo: _ratingInfo!,
                        reviews: _reviews,
                        onAddReview: _openAddReview,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final String cafeName;
  const _AppBar({required this.cafeName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _lightGreenBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  CupertinoIcons.arrow_left,
                  size: 20,
                  color: _textDark,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'التقييمات والتعليقات',
                style: GoogleFonts.cairo(
                  color: CupertinoColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                cafeName,
                style: GoogleFonts.cairo(
                  color: const Color(0xCCFFFFFF),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final CafeRatingInfo ratingInfo;
  final List<ReviewModel> reviews;
  final VoidCallback onAddReview;

  const _Body({
    required this.ratingInfo,
    required this.reviews,
    required this.onAddReview,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _RatingSummaryCard(info: ratingInfo),
              const SizedBox(height: 14),
              _AddRatingButton(onTap: onAddReview),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  '${ratingInfo.totalReviews} تعليق',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: const Color(0xFF3B6D11).withOpacity(0.83),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          sliver: reviews.isEmpty
              ? SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'لا توجد تعليقات بعد\nكن أول من يقيّم!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    color: const Color(0xFF3B6D11).withOpacity(0.6),
                    height: 1.8,
                  ),
                ),
              ),
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ReviewCard(review: reviews[i]),
              ),
              childCount: reviews.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingSummaryCard extends StatelessWidget {
  final CafeRatingInfo info;
  const _RatingSummaryCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2D5A1B), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _RatingBars(fractions: info.barFractions)),
          const SizedBox(width: 20),
          Column(
            children: [
              Text(
                info.avgRating.toStringAsFixed(1),
                style: GoogleFonts.cairo(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: _ratingGreen,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              _StarRow(rating: info.avgRating, size: 20),
              const SizedBox(height: 4),
              Text(
                '${info.totalReviews} تقييم',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: const Color(0xFF888888),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingBars extends StatelessWidget {
  final List<double> fractions;
  static const _barColors = [
    Color(0xFF2196F3),
    Color(0xFF2196F3),
    Color(0xFFF5A623),
    Color(0xFFF5A623),
    Color(0xFF4CAF50),
  ];

  const _RatingBars({required this.fractions});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(fractions.length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: LayoutBuilder(builder: (_, bc) {
            return Container(
              height: 7,
              width: bc.maxWidth,
              decoration: BoxDecoration(
                color: _starEmpty,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerRight,
                widthFactor: fractions[i].clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _barColors[i],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}

class _AddRatingButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AddRatingButton({required this.onTap});

  @override
  State<_AddRatingButton> createState() => _AddRatingButtonState();
}

class _AddRatingButtonState extends State<_AddRatingButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _isPressed
              ? const Color(0xFF2D5A1B).withOpacity(0.1)
              : _cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2D5A1B), width: 1),
          boxShadow: _isPressed
              ? []
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'أضف تقييمك',
          style: GoogleFonts.cairo(
            color: const Color(0xFF3B6D11),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2D5A1B), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: review.avatarColor,
                  child: Text(
                    review.avatarLabel,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: const Color(0xFF3B6D11),
                        ),
                      ),
                      Text(
                        review.date,
                        style: GoogleFonts.cairo(
                          fontSize: 9,
                          color: const Color(0xFF3B6D11).withOpacity(0.67),
                        ),
                      ),
                    ],
                  ),
                ),
                _StarRow(rating: review.rating.toDouble(), size: 16),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.comment,
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: const Color(0xFF3B6D11),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final double rating;
  final double size;
  const _StarRow({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final icon = rating >= i + 1
            ? Icons.star_rounded
            : rating >= i + 0.5
            ? Icons.star_half_rounded
            : Icons.star_outline_rounded;
        return Icon(
          icon,
          color: icon == Icons.star_outline_rounded ? _starEmpty : _starGold,
          size: size,
        );
      }),
    );
  }
}

class AddReviewSheet extends StatefulWidget {
  final String cafeId;
  final VoidCallback onSubmitted;

  const AddReviewSheet({
    super.key,
    required this.cafeId,
    required this.onSubmitted,
  });

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  int _selectedRating = 0;
  final _commentController = TextEditingController();
  bool _submitting = false;
  bool _isPressed = false;

  Future<void> _submit() async {
    if (_selectedRating == 0) return;
    setState(() => _submitting = true);
    try {
      await RatingsService.submitReview(
        cafeId: widget.cafeId,
        userId: 'current_user_id',
        userName: 'المستخدم',
        rating: _selectedRating,
        comment: _commentController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onSubmitted();
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('حدث خطأ'),
          content: Text('فشل إرسال التقييم: $e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('حسناً'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          color: _cardWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _starEmpty,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'أضف تقييمك',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedRating = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      i < _selectedRating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: i < _selectedRating ? _starGold : _starEmpty,
                      size: 40,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            CupertinoTextField(
              controller: _commentController,
              placeholder: 'اكتب تعليقك هنا...',
              maxLines: 4,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _lightGreenBg,
                borderRadius: BorderRadius.circular(12),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: (_selectedRating == 0 || _submitting) ? null : _submit,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _isPressed
                      ? const Color(0xFF1E3D0A)
                      : (_selectedRating == 0 || _submitting)
                      ? const Color(0xFF2D5A1B).withOpacity(0.4)
                      : const Color(0xFF2D5A1B),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _isPressed
                      ? []
                      : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: _submitting
                    ? const CupertinoActivityIndicator(
                    color: CupertinoColors.white)
                    : Text(
                  'إرسال التقييم',
                  style: GoogleFonts.cairo(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveBackground extends StatelessWidget {
  const _WaveBackground();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        'assets/backgrounds/background.png',
        fit: BoxFit.cover,
      ),
    );
  }
}