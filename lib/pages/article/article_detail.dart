import 'package:flutter/material.dart';
import 'package:potato_market/components/buy_bottom_bar.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/api_service.dart';
import '../../models/article.dart';
import '../../utils/format_utils.dart';
import '../../components/skeleton_loader.dart';

class ArticleDetail extends StatefulWidget {
  final int articleId;
  final String articleTitle;

  const ArticleDetail({
    super.key,
    required this.articleId,
    required this.articleTitle,
  });

  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  final PageController _pageController = PageController();
  final ApiService _apiService = ApiService();

  int _currentPage = 0;
  Article? _article;
  bool _isLoading = true;
  String? _error;
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _loadArticle();
  }

  Future<void> _deleteArticle() async {
    try {
      await _apiService.deleteArticle(id: widget.articleId);

      setState(() {
        Navigator.pop(context);
      });
      ;
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> _loadArticle() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('게시글 ID로 요청: ${widget.articleId}');
      final article = await _apiService.getArticle(widget.articleId);
      print('받은 게시글 데이터: ${article.title}');

      setState(() {
        _article = article;
        _images = article.images ?? [];
        if (_images.isEmpty) {
          _images = ['placeholder'];
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('게시글 로딩 에러: $e');
      print('요청한 게시글 ID: ${widget.articleId}');
    }
  }

  Color _getTemperatureColor(double? temperature) {
    if (temperature == null) return Colors.blue;

    if (temperature <= 40.0) {
      return Colors.blue;
    } else if (temperature <= 70.0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getTemperatureBackgroundColor(double? temperature) {
    if (temperature == null) return Colors.blue[50]!;

    if (temperature <= 40.0) {
      return Colors.blue[50]!;
    } else if (temperature <= 70.0) {
      return Colors.orange[50]!;
    } else {
      return Colors.red[50]!;
    }
  }

  Color _getTemperatureBorderColor(double? temperature) {
    if (temperature == null) return Colors.blue[200]!;

    if (temperature <= 40.0) {
      return Colors.blue[200]!;
    } else if (temperature <= 70.0) {
      return Colors.orange[200]!;
    } else {
      return Colors.red[200]!;
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (_isLoading) {
      return const ArticleDetailSkeleton();
    }

    if (_error != null || _article == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('게시글을 불러올 수 없습니다', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('에러: $_error', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Text('게시글 ID: ${widget.articleId}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadArticle,
                child: const Text('다시 시도'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('돌아가기'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        bottomNavigationBar: BuyBottomBar(
          id: _article!.id!,
          price: FormatUtils.formatPrice(_article!.price),
          isNegotiation: _article!.isNegotiable ?? false,
          isMe: _article!.isMe ?? false,
          isLiked: _article!.isLiked ?? false,
          sellerName: _article!.user?.name ?? '알 수 없음',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      final imageUrl = _images[index];

                      if (imageUrl == 'placeholder' || imageUrl.isEmpty) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, size: 80, color: Colors.grey),
                                SizedBox(height: 8),
                                Text('이미지 없음',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      }

                      return Image.network(
                        'http://localhost:3000$imageUrl',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: CircularProgressIndicator(
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
                            color: Colors.grey[300],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.broken_image,
                                      size: 50, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('이미지 로딩 실패',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Share.share(
                            'https://google.com',
                            subject: widget.articleTitle,
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(Icons.share,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () => print('메뉴'),
                      //   child: Container(
                      //     width: 44,
                      //     height: 44,
                      //     decoration: BoxDecoration(
                      //       color: Colors.black.withOpacity(0.3),
                      //       borderRadius: BorderRadius.circular(22),
                      //     ),
                      //     child: const Icon(Icons.more_vert,
                      //         color: Colors.white, size: 20),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '${_currentPage + 1} / ${_images.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              // 사용자 정보 섹션
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Icon(Icons.person, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _article!.user?.name ?? '익명',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              _article!.user?.location ??
                                  _article!.location ??
                                  '알 수 없음',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // 매너온도 (간소화된 버전)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getTemperatureBackgroundColor(
                            _article!.user?.temperature),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getTemperatureBorderColor(
                              _article!.user?.temperature),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.thermostat,
                            color: _getTemperatureColor(
                                _article!.user?.temperature),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_article!.user?.temperature?.toStringAsFixed(1) ?? "36.5"}°C',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _getTemperatureColor(
                                  _article!.user?.temperature),
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
                color: Colors.grey.shade200,
                indent: 16,
                endIndent: 16,
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _article!.title ?? '제목 없음',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${_article!.category ?? '기타'}  ${FormatUtils.formatDateTime(_article!.createdAt)}",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w200),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(_article!.content ?? '내용 없음'),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            "조회 ${_article!.views ?? 0}",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w200),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "좋아요 ${_article!.likeCount ?? 0}",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w200),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
