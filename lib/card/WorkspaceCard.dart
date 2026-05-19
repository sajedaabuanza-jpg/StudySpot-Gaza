import 'package:flutter/material.dart';

class WorkspaceCard extends StatefulWidget {
  final String title;
  final String location;
  final String imagePath;
  final double rating;

  const WorkspaceCard({
    super.key,
    required this.title,
    required this.location,
    required this.imagePath,
    required this.rating,
  });

  @override
  State<WorkspaceCard> createState() => _WorkspaceCardState();
}

class _WorkspaceCardState extends State<WorkspaceCard> {
  bool isFavorite = false; // حالة النجمة (مفضلة أم لا)

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // للغة العربية
        children: [
          // الجزء العلوي: الصورة مع نجمة المفضلة
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  widget.imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    // هنا يمكن إضافة الكود لإضافة المكان لقائمة المفضلة فعلياً
                  },
                  child: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.yellow : Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ],
          ),

          // الجزء السفلي: المعلومات والتقييم
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  widget.location,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 5),
                // عرض نجوم التقييم
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < widget.rating ? Icons.star : Icons.star_border,
                      color: Colors.green,
                      size: 20,
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}