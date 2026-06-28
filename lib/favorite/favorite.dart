
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:studyspot/city.dart';
// import 'package:studyspot/details/add_workspace_screen.dart';
// import 'package:studyspot/details/workspace_details_page.dart';
// import 'package:studyspot/favorite/favorites_service.dart';
// // اناااااا

// class favorite extends StatelessWidget {
//   const favorite({super.key});

//   static const _designWidth = 390.0;

//   double _parseRating(String? qualityScores) {
//     if (qualityScores == null || qualityScores.isEmpty) return 5.0;
//     try {
//       final pairs = qualityScores.split('|');
//       double total = 0;
//       int count = 0;
//       for (var pair in pairs) {
//         final parts = pair.split(':');
//         if (parts.length == 2) {
//           final score = double.tryParse(parts[1]);
//           if (score != null) {
//             total += score;
//             count++;
//           }
//         }
//       }
//       return count > 0 ? (total / count) : 5.0;
//     } catch (e) {
//       return 5.0;
//     }
//   }

//   List<_FavoriteSpace> _favoriteSpacesFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
//     return snapshot.docs.map((doc) {
//       final data = Map<String, dynamic>.from(doc.data());
//       // final workspaceId = (data['workspaceId'] ?? doc.id).toString();
//       final workspaceId = (data['workspaceId'] ?? data['id'] ?? doc.id).toString();
//       data['id'] = workspaceId;
//       return _FavoriteSpace(
//         workspaceId: workspaceId,
//         name: data['name'] ?? 'بدون اسم',
//         address: "${data['city'] ?? ''} - ${data['district'] ?? ''}",
//         rating: _parseRating(data['quality_scores']),
//         imageUrl: data['image_url'] ?? '',
//         workspace: data,
//       );
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final scale = (size.width / _designWidth) * 0.5;
//     double s(double v) => v * scale;
//     final navHeight = s(100);
//     final uid = FirebaseAuth.instance.currentUser?.uid;

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Stack(
//           children: [
//             Positioned.fill(
//               child: SvgPicture.asset(
//                 'assets/backgrounds/favorites_background.svg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: navHeight),
//                 child: uid == null
//                     ? CustomScrollView(
//                         slivers: [
//                           SliverToBoxAdapter(child: SizedBox(height: s(8))),
//                           SliverPadding(
//                             padding: EdgeInsets.symmetric(horizontal: s(24)),
//                             sliver: SliverToBoxAdapter(child: _Header(scale: scale)),
//                           ),
//                           SliverToBoxAdapter(child: SizedBox(height: s(40))),
//                           SliverPadding(
//                             padding: EdgeInsets.symmetric(horizontal: s(24)),
//                             sliver: SliverToBoxAdapter(
//                               child: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: _TitleAndCount(count: 0, scale: scale),
//                               ),
//                             ),
//                           ),
//                           SliverFillRemaining(
//                             hasScrollBody: true,
//                             child: _EmptyState(scale: scale),
//                           ),
//                         ],
//                       )
//                     : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                         // stream: FirebaseFirestore.instance
//                         //     .collection('users')
//                         //     .doc(uid)
//                         //     .collection('favorites')
//                         //     .snapshots(),
//                         stream: FavoritesService().getFavorites(),
//                         builder: (context, snapshot) {
//                           // final favoriteSpaces = snapshot.hasData ? _favoriteSpacesFromSnapshot(snapshot.data!) : <_FavoriteSpace>[];
//                           final favoriteSpaces =
//                             snapshot.data != null
//                               ? _favoriteSpacesFromSnapshot(snapshot.data!)
//                               : <_FavoriteSpace>[];
//                           return CustomScrollView(
//                             slivers: [
//                               SliverToBoxAdapter(child: SizedBox(height: s(8))),
//                               SliverPadding(
//                                 padding: EdgeInsets.symmetric(horizontal: s(24)),
//                                 sliver: SliverToBoxAdapter(child: _Header(scale: scale)),
//                               ),
//                               SliverToBoxAdapter(child: SizedBox(height: s(40))),
//                               SliverPadding(
//                                 padding: EdgeInsets.symmetric(horizontal: s(24)),
//                                 sliver: SliverToBoxAdapter(
//                                   child: Align(
//                                     alignment: Alignment.centerRight,
//                                     child: _TitleAndCount(
//                                       count: favoriteSpaces.length,
//                                       scale: scale,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SliverToBoxAdapter(child: SizedBox(height: s(28))),
//                               if (snapshot.connectionState == ConnectionState.waiting)
//                                 const SliverFillRemaining(
//                                   hasScrollBody: false,
//                                   child: Center(child: CircularProgressIndicator(color: Color(0xFF3B6D11))),
//                                 )
//                               else if (snapshot.hasError)
//                                 const SliverFillRemaining(
//                                   hasScrollBody: false,
//                                   child: Center(child: Text("حدث خطأ أثناء تحميل المفضلة")),
//                                 )
//                               else if (favoriteSpaces.isEmpty)
//                                 SliverFillRemaining(
//                                   hasScrollBody: true,
//                                   child: LayoutBuilder(
//                                     builder: (context, constraints) {
//                                       return SingleChildScrollView(
//                                         physics: const ClampingScrollPhysics(),
//                                         child: ConstrainedBox(
//                                           constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                                           child: Center(
//                                             child: _EmptyState(scale: scale),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 )
//                               else
//                                 SliverPadding(
//                                   padding: EdgeInsets.symmetric(horizontal: s(24)),
//                                   sliver: SliverList(
//                                     delegate: SliverChildBuilderDelegate(
//                                       (context, index) {
//                                         final isLast = index == favoriteSpaces.length - 1;
//                                         return Padding(
//                                           padding: EdgeInsets.only(bottom: isLast ? 0 : s(18)),
//                                           child: _FavoriteCard(
//                                             scale: scale,
//                                             space: favoriteSpaces[index],
//                                           ),
//                                         );
//                                       },
//                                       childCount: favoriteSpaces.length,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           );
//                         },
//                       ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: _BottomNav(scale: scale),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _FavoriteSpace {
//   const _FavoriteSpace({
//     required this.workspaceId,
//     required this.name,
//     required this.address,
//     required this.rating,
//     required this.imageUrl,
//     required this.workspace,
//   });

//   final String workspaceId;
//   final String name;
//   final String address;
//   final double rating;
//   final String imageUrl;
//   final Map<String, dynamic> workspace;
// }

// class _Header extends StatelessWidget {
//   const _Header({required this.scale});

//   final double scale;

//   double s(double v) => v * scale;

//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: BoxConstraints(minHeight: s(120)),
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.topRight,
//             child: IconButton(
//               onPressed: () {},
//               padding: EdgeInsets.zero,
//               icon: Icon(
//                 Icons.menu,
//                 size: s(34),
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.topCenter,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(height: s(6)),
//                 _BrandMark(scale: scale),
//                 SizedBox(height: s(10)),
//                 Text(
//                   'مكاني',
//                   style: TextStyle(
//                     fontFamily: 'Tajawal',
//                     fontSize: s(36),
//                     fontWeight: FontWeight.w700,
//                     color: const Color(0xFF3B6D11),
//                     height: 1.0,
//                   ),
//                 ),
//                 SizedBox(height: s(10)),
//                 Text(
//                   'STUDYSPOT GAZA',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'DM Sans',
//                     fontSize: s(22),
//                     fontWeight: FontWeight.w400,
//                     letterSpacing: s(4.4),
//                     color: const Color(0xFF2C2C2C),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BrandMark extends StatelessWidget {
//   const _BrandMark({required this.scale});

//   final double scale;

//   double s(double v) => v * scale;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: s(70),
//       height: s(28),
//       child: Stack(
//         children: [
//           Positioned(
//             left: 0,
//             bottom: 0,
//             child: _BrandSquare(scale: scale),
//           ),
//           Positioned(
//             left: s(24),
//             bottom: 0,
//             child: _BrandSquare(scale: scale),
//           ),
//           Positioned(
//             right: 0,
//             top: 0,
//             child: Container(
//               width: s(12),
//               height: s(12),
//               decoration: const BoxDecoration(
//                 color: Color(0xFF97C459),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BrandSquare extends StatelessWidget {
//   const _BrandSquare({required this.scale});

//   final double scale;

//   double s(double v) => v * scale;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: s(26),
//       height: s(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF3B6D11),
//         borderRadius: BorderRadius.circular(s(4)),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x40000000),
//             blurRadius: 6,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Container(
//           width: s(18),
//           height: s(3),
//           color: const Color(0xFF97C459),
//         ),
//       ),
//     );
//   }
// }

// class _TitleAndCount extends StatelessWidget {
//   const _TitleAndCount({required this.count, required this.scale});

//   final int count;
//   final double scale;

//   double s(double v) => v * scale;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Text(
//           'المفضلة',
//           style: TextStyle(
//             fontFamily: 'Tajawal',
//             fontSize: s(36),
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF3B6D11),
//           ),
//         ),
//         SizedBox(height: s(10)),
//         Container(
//           width: s(150),
//           height: s(44),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: const Color(0xFFD4ECCE),
//             borderRadius: BorderRadius.circular(s(14)),
//           ),
//           child: Text(
//             'أماكن $count',
//             style: TextStyle(
//               fontFamily: 'Tajawal',
//               fontSize: s(18),
//               fontWeight: FontWeight.w500,
//               color: const Color(0xFF3B6D11),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _FavoriteCard extends StatelessWidget {
//   const _FavoriteCard({required this.scale, required this.space});

//   final double scale;
//   final _FavoriteSpace space;

//   double s(double v) => v * scale;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => workspace_details_page(workspace: space.workspace),
//           ),
//         );
//       },
//       onLongPress: () => _confirmDelete(context),
//       child: Container(
//         height: s(175),
//         padding: EdgeInsets.symmetric(horizontal: s(22), vertical: s(18)),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(s(30)),
//         ),
//         child: Row(
//           textDirection: TextDirection.rtl,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(s(22)),
//               child: _buildImage(),
//             ),
//             SizedBox(width: s(18)),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     space.name,
//                     textAlign: TextAlign.center,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontFamily: 'Tajawal',
//                       fontSize: s(28),
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xFF3B6D11),
//                     ),
//                   ),
//                   SizedBox(height: s(8)),
//                   Text(
//                     space.address,
//                     textAlign: TextAlign.center,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontFamily: 'Tajawal',
//                       fontSize: s(20),
//                       fontWeight: FontWeight.w400,
//                       color: const Color(0xFF3B6D11),
//                     ),
//                   ),
//                   SizedBox(height: s(12)),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: List.generate(
//                       5,
//                       (i) => Icon(
//                         i < space.rating.round() ? Icons.star : Icons.star_border,
//                         size: s(28),
//                         color: const Color(0xFFFF9719),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildImage() {
//     // if (space.imageUrl.startsWith('http')) {
//     if (space.imageUrl.isNotEmpty && space.imageUrl.startsWith('http')){
//       return Image.network(
//         space.imageUrl,
//         width: s(110),
//         height: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
//       );
//     }
//     return _imagePlaceholder();
//   }

//   Widget _imagePlaceholder() {
//     return Container(
//       width: s(110),
//       height: double.infinity,
//       color: const Color(0xFFD4ECCE),
//       child: Icon(Icons.image_not_supported, color: const Color(0xFF3B6D11), size: s(36)),
//     );
//   }

//   Future<void> _confirmDelete(BuildContext context) async {
//     final shouldDelete = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("حذف من المفضلة"),
//         content: Text("هل تريد حذف ${space.name} من المفضلة؟"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text("إلغاء"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text("حذف"),
//           ),
//         ],
//       ),
//     );

//     if (shouldDelete != true) return;

//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     // await FirebaseFirestore.instance
//     //     .collection('users')
//     //     .doc(uid)
//     //     .collection('favorites')
//     //     .doc(space.workspaceId)
//     //     .delete();
//     await FavoritesService().removeFavorite(space.workspaceId);
    
//   }
// }

// class _EmptyState extends StatelessWidget {
//   const _EmptyState({required this.scale});

//   final double scale;

//   double s(double v) => v * scale;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: s(24)),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: s(150),
//               height: s(150),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFC4E7C2),
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Icon(
//                   Icons.favorite_border,
//                   size: s(60),
//                   color: const Color(0xFF3B6D11),
//                 ),
//               ),
//             ),
//             SizedBox(height: s(42)),
//             Text(
//               'لا يوجد أماكن محفوظة بعد',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'Tajawal',
//                 fontSize: s(30),
//                 fontWeight: FontWeight.w700,
//                 color: const Color(0xFF3B6D11),
//               ),
//             ),
//             SizedBox(height: s(18)),
//             Text(
//               'احفظ مساحاتك المفضلة واصل\nإليها بشكل أسرع',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'Tajawal',
//                 fontSize: s(24),
//                 fontWeight: FontWeight.w400,
//                 color: const Color(0xFF97C459),
//                 height: 1.2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _BottomNav extends StatelessWidget {
//   const _BottomNav({required this.scale});

//   final double scale;

//   double s(double v) => v * scale;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       child: SizedBox(
//         height: s(95),
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             // الخلفية + الأزرار الجانبية
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: s(70),
//                 width: double.infinity,
//                 color: const Color(0xFF3B6D11),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _BottomNavItem(
//                       icon: Icons.home_outlined,
//                       label: 'الرئيسية',
//                       scale: scale,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const city(),
//                           ),
//                         );
//                       },
//                     ),
//                     _BottomNavItem(
//                       icon: Icons.add_location_alt_outlined,
//                       label: 'أضف مساحتك',
//                       scale: scale,
//                       onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const AddWorkspaceScreen(),
//                             ),
//                           );
//                       },
//                     ),
//                     Transform.translate(
//                       offset: const Offset(0, -20), // كلما زاد الرقم طلعت لفوق أكثر
//                       child: _BottomNavItem(
//                         icon: Icons.star_border,
//                         label: '',
//                         scale: scale,
//                         isCenter: true,
//                         onTap: () {},
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _BottomNavItem extends StatelessWidget {
//   const _BottomNavItem({
//     required this.icon,
//     required this.label,
//     required this.scale,
//     required this.onTap,
//     this.isCenter = false,
//   });
//   final IconData icon;
//   final String label;
//   final double scale;
//   final VoidCallback onTap;
//   final bool isCenter;

//   double s(double v) => v * scale;

//   @override
//   Widget build(BuildContext context) {
//     if (isCenter) {
//       return GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: s(100),
//           height: s(100),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: const Color(0xFF3B6D11),
//               width: s(7),
//             ),
//           ),
//           child: Icon(
//             icon,
//             size: s(47),
//             color: Colors.black,
//           ),
//         ),
//       );
//     }

//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: s(32), // حجم الأيقونة
//             color: Colors.white, // لون الأيقونة
//           ),
//           SizedBox(height: s(4)),
//           if (label.isNotEmpty)
//             Text(
//               label,
//               style: TextStyle(
//                 fontFamily: 'Tajawal',
//                 fontSize: s(18), // كبر الخط
//                 fontWeight: FontWeight.w700,
//                 color: Colors.white, // لون النص
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studyspot/city.dart';
import 'package:studyspot/details/add_workspace_screen.dart';
// import 'package:studyspot/details/add_workspace_screen.dart';
import 'package:studyspot/details/workspace_details_page.dart';
import 'package:studyspot/favorite/favorites_service.dart';
// اناااااا

class favorite extends StatelessWidget {
  const favorite({super.key});

  static const _designWidth = 390.0;
  static final FavoritesService _favoritesService = FavoritesService();

  double _parseRating(String? qualityScores) {
    if (qualityScores == null || qualityScores.isEmpty) return 5.0;
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
      return count > 0 ? (total / count) : 5.0;
    } catch (e) {
      return 5.0;
    }
  }

  List<_FavoriteSpace> _favoriteSpacesFromWorkspaces(
    List<Map<String, dynamic>> workspaces,
  ) {
    return workspaces.map((workspace) {
      final data = Map<String, dynamic>.from(workspace);
      final workspaceId = (data['workspaceId'] ?? data['id']).toString();
      return _FavoriteSpace(
        workspaceId: workspaceId,
        name: data['name'] ?? 'بدون اسم',
        address: "${data['city'] ?? ''} - ${data['district'] ?? ''}",
        rating: _parseRating(data['quality_scores']),
        imageUrl: data['image_url'] ?? '',
        workspace: data,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.width / _designWidth) * 0.5;
    double s(double v) => v * scale;
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
                child: StreamBuilder<List<String>>(
                  stream: _favoritesService.getFavoriteWorkspaceIds(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _FavoritesLayout(
                        scale: scale,
                        loading: true,
                        favoriteSpaces: const [],
                      );
                    }

                    if (snapshot.hasError) {
                      return _FavoritesLayout(
                        scale: scale,
                        errorMessage: "حدث خطأ أثناء تحميل المفضلة",
                        favoriteSpaces: const [],
                      );
                    }

                    final workspaceIds = snapshot.data ?? const <String>[];
                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: _favoritesService.getWorkspacesByIds(
                        workspaceIds,
                      ),
                      builder: (context, workspaceSnapshot) {
                        final favoriteSpaces = workspaceSnapshot.hasData
                            ? _favoriteSpacesFromWorkspaces(
                                workspaceSnapshot.data!,
                              )
                            : <_FavoriteSpace>[];

                        return _FavoritesLayout(
                          scale: scale,
                          loading:
                              workspaceSnapshot.connectionState ==
                                  ConnectionState.waiting &&
                              workspaceIds.isNotEmpty,
                          errorMessage: workspaceSnapshot.hasError
                              ? "حدث خطأ أثناء تحميل تفاصيل المفضلة"
                              : null,
                          favoriteSpaces: favoriteSpaces,
                        );
                      },
                    );
                  },
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
    required this.workspaceId,
    required this.name,
    required this.address,
    required this.rating,
    required this.imageUrl,
    required this.workspace,
  });

  final String workspaceId;
  final String name;
  final String address;
  final double rating;
  final String imageUrl;
  final Map<String, dynamic> workspace;
}

class _FavoritesLayout extends StatelessWidget {
  const _FavoritesLayout({
    required this.scale,
    required this.favoriteSpaces,
    this.loading = false,
    this.errorMessage,
  });

  final double scale;
  final List<_FavoriteSpace> favoriteSpaces;
  final bool loading;
  final String? errorMessage;

  double s(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
              child: _TitleAndCount(count: favoriteSpaces.length, scale: scale),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: s(28))),
        if (loading)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF3B6D11)),
            ),
          )
        else if (errorMessage != null)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text(errorMessage!)),
          )
        else if (favoriteSpaces.isEmpty)
          SliverFillRemaining(
            hasScrollBody: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(child: _EmptyState(scale: scale)),
                  ),
                );
              },
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: s(24)),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final isLast = index == favoriteSpaces.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : s(18)),
                  child: _FavoriteCard(
                    scale: scale,
                    space: favoriteSpaces[index],
                  ),
                );
              }, childCount: favoriteSpaces.length),
            ),
          ),
      ],
    );
  }
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
              icon: Icon(Icons.menu, size: s(34), color: Colors.black),
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
          Positioned(left: 0, bottom: 0, child: _BrandSquare(scale: scale)),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                workspace_details_page(workspace: space.workspace),
          ),
        );
      },
      onLongPress: () => _confirmDelete(context),
      child: Container(
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
              child: _buildImage(),
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
                        i < space.rating.round()
                            ? Icons.star
                            : Icons.star_border,
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
      ),
    );
  }

  Widget _buildImage() {
    if (space.imageUrl.startsWith('http')) {
      return Image.network(
        space.imageUrl,
        width: s(110),
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
      );
    }
    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() {
    return Container(
      width: s(110),
      height: double.infinity,
      color: const Color(0xFFD4ECCE),
      child: Icon(
        Icons.image_not_supported,
        color: const Color(0xFF3B6D11),
        size: s(36),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("حذف من المفضلة"),
        content: Text("هل تريد حذف ${space.name} من المفضلة؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("حذف"),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    await favorite._favoritesService.removeFavorite(space.workspaceId);
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
                          MaterialPageRoute(builder: (context) => const city()),
                        );
                      },
                    ),
                    _BottomNavItem(
                      icon: Icons.add_location_alt_outlined,
                      label: 'أضف مساحتك',
                      scale: scale,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddWorkspaceScreen(),
                            ),
                          );
                      },
                    ),
                    Transform.translate(
                      offset: const Offset(
                        0,
                        -20,
                      ), // كلما زاد الرقم طلعت لفوق أكثر
                      child: _BottomNavItem(
                        icon: Icons.star_border,
                        label: '',
                        scale: scale,
                        isCenter: true,
                        onTap: () {},
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
            border: Border.all(color: const Color(0xFF3B6D11), width: s(7)),
          ),
          child: Icon(icon, size: s(47), color: Colors.black),
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
