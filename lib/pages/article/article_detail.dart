import 'package:flutter/material.dart';
import 'package:potato_market/components/buy_bottom_bar.dart';
import '../../services/api_service.dart';
import '../../models/article.dart';
import '../../utils/format_utils.dart';

class ArticleDetail extends StatefulWidget {
  final int articleId;

  const ArticleDetail({
    super.key,
    required this.articleId,
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
          // 기본 이미지가 없으면 플레이스홀더 추가
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

  @override
  Widget build(BuildContext ctx) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('게시글 상세'),
          backgroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _article == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('게시글 상세'),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('게시글을 불러올 수 없습니다', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('에러: $_error', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Text('게시글 ID: ${widget.articleId}',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadArticle,
                child: Text('다시 시도'),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('돌아가기'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        bottomNavigationBar: BuyBottomBar(
          price: FormatUtils.formatPrice(_article!.price),
          isNegotiation: _article!.isNegotiable ?? false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                // 카로셀 이미지
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

                      // 네트워크 이미지 표시
                      return Image.network(
                        'https://potato-backend-production.up.railway.app$imageUrl',
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
                        onTap: () => print('공유하기'),
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
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => print('메뉴'),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(Icons.more_vert,
                              color: Colors.white, size: 20),
                        ),
                      ),
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
                          style: TextStyle(
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(55))),
                            child: Icon(
                              Icons.person,
                              size: 45,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_article!.user?.name ?? '익명',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                              Text(
                                  _article!.user?.location ??
                                      _article!.location ??
                                      '알 수 없음',
                                  style: TextStyle(fontSize: 12))
                            ]),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                            '${_article!.user?.temperature?.toStringAsFixed(1) ?? '36.5'}'),
                        Text(
                          '매너온도',
                        )
                      ],
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
              SizedBox(
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
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${_article!.category ?? '기타'}  ${FormatUtils.formatDateTime(_article!.createdAt)}",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w200),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(_article!.content ?? '내용 없음'),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "조회 ${_article!.views ?? 0}",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
