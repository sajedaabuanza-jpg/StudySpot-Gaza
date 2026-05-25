import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nearest_work_space/homePage.dart';
import 'package:nearest_work_space/add_workspace_screen.dart';

class favorite extends StatelessWidget {
  const favorite({super.key});

  static const _designWidth = 390.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.width / _designWidth) * 0.5;
    double s(double v) => v * scale;

    // Replace with your real data source (Provider/Bloc/DB/etc.).
    // Set it to `[]` to see the Empty State design.
    final favoriteSpaces = <_FavoriteSpace>[
      _FavoriteSpace(
        name: 'كافيه الزعيم',
        address: 'المواصي - حي العطار',
        rating: 4,
        imageAsset: 'assets/images/hub.jpeg',
      ),
      _FavoriteSpace(
        name: 'مكتبة الأمل',
        address: 'شارع الوحدة - وسط المدينة',
        rating: 5,
        imageAsset: 'assets/images/hub.jpeg',
      ),
      _FavoriteSpace(
        name: 'مركز الشباب',
        address: 'شارع النصر - حي الشجاعية',
        rating: 3,
        imageAsset: 'assets/images/hub.jpeg',
      ),
    ];

    final navHeight = s(100);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/backgrounds/favorites_background.svg',
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: navHeight),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: s(8))),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: s(24)),
                      sliver: SliverToBoxAdapter(child: _Header(scale: scale)),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: s(40))),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: s(24)),
                      sliver: SliverToBoxAdapter(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: _TitleAndCount(
                            count: favoriteSpaces.length,
                            scale: scale,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: s(28))),
                    if (favoriteSpaces.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: true,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight),
                                child: Center(
                                  child: _EmptyState(scale: scale),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: s(24)),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final isLast = index == favoriteSpaces.length - 1;
                              return Padding(
                                padding:
                                    EdgeInsets.only(bottom: isLast ? 0 : s(18)),
                                child: _FavoriteCard(
                                  scale: scale,
                                  space: favoriteSpaces[index],
                                ),
                              );
                            },
                            childCount: favoriteSpaces.length,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _BottomNav(scale: scale),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteSpace {
  const _FavoriteSpace({
    required this.name,
    required this.address,
    required this.rating,
    required this.imageAsset,
  });

  final String name;
  final String address;
  final int rating;
  final String imageAsset;
}

class _Header extends StatelessWidget {
  const _Header({required this.scale});

  final double scale;

  double s(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: s(120)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {},
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.menu,
                size: s(34),
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: s(6)),
                _BrandMark(scale: scale),
                SizedBox(height: s(10)),
                Text(
                  'مكاني',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: s(36),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3B6D11),
                    height: 1.0,
                  ),
                ),
                SizedBox(height: s(10)),
                Text(
                  'STUDYSPOT GAZA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: s(22),
                    fontWeight: FontWeight.w400,
                    letterSpacing: s(4.4),
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.scale});

  final double scale;

  double s(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: s(70),
      height: s(28),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: _BrandSquare(scale: scale),
          ),
          Positioned(
            left: s(24),
            bottom: 0,
            child: _BrandSquare(scale: scale),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: s(12),
              height: s(12),
              decoration: const BoxDecoration(
                color: Color(0xFF97C459),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandSquare extends StatelessWidget {
  const _BrandSquare({required this.scale});

  final double scale;

  double s(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: s(26),
      height: s(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3B6D11),
        borderRadius: BorderRadius.circular(s(4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: s(18),
          height: s(3),
          color: const Color(0xFF97C459),
        ),
      ),
    );
  }
}

class _TitleAndCount extends StatelessWidget {
  const _TitleAndCount({required this.count, required this.scale});

  final int count;
  final double scale;

  double s(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'المفضلة',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: s(36),
            fontWeight: FontWeight.w700,
            color: const Color(0xFF3B6D11),
          ),
        ),
        SizedBox(height: s(10)),
        Container(
          width: s(150),
          height: s(44),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFD4ECCE),
            borderRadius: BorderRadius.circular(s(14)),
          ),
          child: Text(
            'أماكن $count',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: s(18),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF3B6D11),
            ),
          ),
        ),
      ],
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.scale, required this.space});

  final double scale;
  final _FavoriteSpace space;

  double s(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: s(175),
      padding: EdgeInsets.symmetric(horizontal: s(22), vertical: s(18)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(s(30)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(s(22)),
            child: Image.asset(
              space.imageAsset,
              width: s(110),
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: s(18)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  space.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: s(28),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3B6D11),
                  ),
                ),
                SizedBox(height: s(8)),
                Text(
                  space.address,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: s(20),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF3B6D11),
                  ),
                ),
                SizedBox(height: s(12)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < space.rating ? Icons.star : Icons.star_border,
                      size: s(28),
                      color: const Color(0xFFFF9719),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.scale});

  final double scale;

  double s(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: s(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: s(150),
              height: s(150),
              decoration: const BoxDecoration(
                color: Color(0xFFC4E7C2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.favorite_border,
                  size: s(60),
                  color: const Color(0xFF3B6D11),
                ),
              ),
            ),
            SizedBox(height: s(42)),
            Text(
              'لا يوجد أماكن محفوظة بعد',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: s(30),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF3B6D11),
              ),
            ),
            SizedBox(height: s(18)),
            Text(
              'احفظ مساحاتك المفضلة واصل\nإليها بشكل أسرع',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: s(24),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF97C459),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.scale});

  final double scale;

  double s(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: s(95),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // الخلفية + الأزرار الجانبية
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: s(70),
                width: double.infinity,
                color: const Color(0xFF3B6D11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _BottomNavItem(
                      icon: Icons.home_outlined,
                      label: 'الرئيسية',
                      scale: scale,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => homePage(),
                          ),
                        );
                      },
                    ),
                    _BottomNavItem(
                      icon: Icons.add_location_alt_outlined,
                      label: 'أضف مساحتك',
                      scale: scale,
                      onTap: () {},
                    ),
                    Transform.translate(
                      offset: Offset(0, -20), // كلما زاد الرقم طلعت لفوق أكثر
                      child: _BottomNavItem(
                        icon: Icons.star_border,
                        label: '',
                        scale: scale,
                        isCenter: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddWorkspaceScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.scale,
    required this.onTap,
    this.isCenter = false,
  });
  final IconData icon;
  final String label;
  final double scale;
  final VoidCallback onTap;
  final bool isCenter;

  double s(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    if (isCenter) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: s(100),
          height: s(100),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF3B6D11),
              width: s(7),
            ),
          ),
          child: Icon(
            icon,
            size: s(47),
            color: Colors.black,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: s(32), // حجم الأيقونة
            color: Colors.white, // لون الأيقونة
          ),
          SizedBox(height: s(4)),
          if (label.isNotEmpty)
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: s(18), // كبر الخط
                fontWeight: FontWeight.w700,
                color: Colors.white, // لون النص
              ),
            ),
        ],
      ),
    );
  }
}
