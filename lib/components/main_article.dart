import 'package:flutter/material.dart';

class MainArticle extends StatefulWidget {
  final String productName;
  final String hometown;
  final String price;
  final String uploadedAt;
  final bool isReserving;
  final String? imageUrl;
  final int view;
  final int likeCount;

  const MainArticle(
      {super.key,
      required this.productName,
      required this.hometown,
      required this.price,
      required this.uploadedAt,
      required this.isReserving,
      required this.view,
      required this.likeCount,
      this.imageUrl});

  @override
  _MainArticleState createState() => _MainArticleState();
}

class _MainArticleState extends State<MainArticle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      width: double.infinity, // 전체 폭 확보
      child: Column(
        children: [
          Container(
            width: double.infinity, // 터치 영역 확장
            padding: const EdgeInsets.all(16),
            color: Colors.transparent, // 터치 영역을 위한 투명 배경
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                      ? Image.network(
                          'http://localhost:3000${widget.imageUrl}',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            color: Colors.grey,
                          ),
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
                            fontSize: 16, fontWeight: FontWeight.w500),
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
                          fontWeight: FontWeight.bold,
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
                SizedBox(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 18,
                      ),
                      Text(
                        widget.view.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.grey,
                        size: 18,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        widget.likeCount.toString(),
                        style: TextStyle(color: Colors.grey),
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
            color: Colors.grey.shade200,
            indent: 16,
            endIndent: 16,
          ),
        ],
      ),
    );
  }
}
