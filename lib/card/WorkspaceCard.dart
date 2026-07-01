import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyspot/favorite/favorites_service.dart';

class WorkspaceCard extends StatefulWidget {
  final String workspaceId;
  final String title;
  final String location;
  final String imagePath;
  final double rating;
  final VoidCallback onTap;

  const WorkspaceCard({
    super.key,
    required this.workspaceId,
    required this.title,
    required this.location,
    required this.imagePath,
    required this.rating,
    required this.onTap,
  });

  @override
  State<WorkspaceCard> createState() => _WorkspaceCardState();
}

class _WorkspaceCardState extends State<WorkspaceCard> {
  final FavoritesService _favoritesService = FavoritesService();

  // ✨ دالة ذكية لإصلاح روابط ImgBB العادية وتحويلها لروابط مباشرة تلقائياً
  String _getCleanImageUrl(String url) {
    if (url.contains('ibb.co/') && !url.contains('i.ibb.co/')) {
      // تحويل الرابط من ibb.co/XYZ إلى رابط السيرفر المباشر i.ibb.co/XYZ/image.png
      final segments = url.split('/');
      if (segments.isNotEmpty) {
        final id = segments.last;
        return 'https://i.ibb.co/$id/image.png';
      }
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final cleanUrl = _getCleanImageUrl(widget.imagePath.trim());

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // اتجاه المحاذاة لليمين متوافق مع العربي
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: cleanUrl.isEmpty || !cleanUrl.startsWith('http')
                      ? Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        )
                      : Image.network(
                          cleanUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          // 🛡️ معالجة الأخطاء المحسنة لمنع انهيار الكرت تماماً
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "رابط الصورة غير مدعوم أو تالف",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                      fontFamily: 'Cairo',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey[100],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF386A1B),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                // زر المفضلة (الـ Star) موضوع بأعلى اليمين بشكل متناسق مع اتجاه التطبيق
                Positioned(
                  top: 10,
                  right: 10,
                  child: StreamBuilder<User?>(
                    stream: _favoritesService.authStateChanges,
                    builder: (context, authSnapshot) {
                      final user = authSnapshot.data;
                      if (user == null) {
                        return _FavoriteIconButton(
                          isFavorite: false,
                          onTap: () => _showSignInMessage(context),
                        );
                      }

                      return StreamBuilder<bool>(
                        stream: _favoritesService.isFavoriteForUser(
                          user.uid,
                          widget.workspaceId,
                        ),
                        builder: (context, snapshot) {
                          final isFavorite = snapshot.data ?? false;

                          return _FavoriteIconButton(
                            isFavorite: isFavorite,
                            onTap: () async {
                              try {
                                await _favoritesService.toggleFavorite(
                                  widget.workspaceId,
                                  isFavorite,
                                );
                              } catch (_) {
                                if (!context.mounted) return;
                                _showSignInMessage(context);
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Cairo',
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.location,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Cairo',
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  // عرض النجوم بشكل متناسق يبدأ من اليمين
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    textDirection: TextDirection.rtl,
                    children: [
                      Wrap(
                        spacing: 2,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xFF386A1B),
                            size: 20,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF386A1B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignInMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سجّل الدخول أولاً لحفظ المفضلة')),
    );
  }
}

class _FavoriteIconButton extends StatelessWidget {
  const _FavoriteIconButton({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(4),
        child: Icon(
          isFavorite ? Icons.star : Icons.star_border,
          color: isFavorite ? Colors.yellow : Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
