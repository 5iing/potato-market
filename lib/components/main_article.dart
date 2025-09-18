import 'package:flutter/material.dart';

class MainArticle extends StatefulWidget {
  final String productName;
  final String hometown;
  final String price;
  final String uploadedAt;

  const MainArticle({
    super.key,
    required this.productName,
    required this.hometown,
    required this.price,
    required this.uploadedAt,
  });

  @override
  _MainArticleState createState() => _MainArticleState();
}

class _MainArticleState extends State<MainArticle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 이미지 섹션
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'lib/assets/switch.jpeg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.image_not_supported,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // 텍스트 정보 섹션
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            widget.hometown,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.uploadedAt,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey.shade300,
            indent: 16,
            endIndent: 16,
          ),
        ],
      ),
    );
  }
}
