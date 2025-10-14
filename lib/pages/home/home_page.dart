import 'package:flutter/material.dart';
import 'package:potato_market/pages/article/article_detail.dart';
import 'package:potato_market/pages/write_article/write_article.dart';
import '../../components/main_article.dart';
import '../../services/api_service.dart';
import '../../models/article.dart';
import '../../utils/format_utils.dart';
import '../../components/skeleton_loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _dropdownMenus = ['동패동', '목동동', '교하동'];
  String? _selectedMenu;
  final ApiService _apiService = ApiService();
  List<Article> _articles = [];
  bool _isLoading = true;
  String? _error;
  final bool? result = false;

  @override
  void initState() {
    super.initState();
    _selectedMenu = _dropdownMenus[0];
    // _loadUserInfo();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final articles = await _apiService.getArticles(
        location: _selectedMenu,
        limit: 20,
      );

      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('게시글 로딩 에러: $e');
    }
  }

  // Future<void> _loadUserInfo() async {
  //   try {
  //     final user = await _apiService.getUserProfile();
  //   } catch (e) {
  //     throw Exception('사용자 정보 불러오기 에러: $e');
  //   }
  // }

  Future<void> _refreshArticles() async {
    await _loadArticles();
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 핸들바
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // 제목
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.orange[600], size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    '지역을 선택해주세요',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 지역 리스트
            ...(_dropdownMenus
                .map((location) => InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMenu = location;
                        });
                        _loadArticles();
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _selectedMenu == location
                                    ? Colors.orange[600]
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedMenu == location
                                      ? Colors.orange[600]!
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              location,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: _selectedMenu == location
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: _selectedMenu == location
                                    ? Colors.orange[700]
                                    : Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            if (_selectedMenu == location)
                              Icon(
                                Icons.check,
                                color: Colors.orange[600],
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ))
                .toList()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const MainArticleSkeleton();
        },
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '데이터를 불러올 수 없습니다',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadArticles,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (_articles.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '등록된 상품이 없습니다',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _articles.length + 1, // +1 for divider
      itemBuilder: (context, index) {
        if (index == 0) {
          return Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey.shade200,
            indent: 16,
            endIndent: 16,
          );
        }

        final article = _articles[index - 1];
        return InkWell(
          onTap: () {
            if (article.id != null) {
              print('상세페이지로 이동: 게시글 ID ${article.id}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetail(
                    articleId: article.id!,
                  ),
                ),
              );
            } else {
              print('게시글 ID가 null입니다');
            }
          },
          splashColor: Colors.grey[200], // 터치 시 물결 효과
          highlightColor: Colors.grey[100], // 터치 시 하이라이트
          child: MainArticle(
            productName: article.title ?? '제목 없음',
            hometown: article.location ?? '알 수 없음',
            price: FormatUtils.formatPrice(article.price),
            uploadedAt: FormatUtils.formatDateTime(article.createdAt),
            isReserving: article.status == 'reserved',
            view: article.views ?? 0,
            likeCount: article.likeCount ?? 0,
            imageUrl: article.images?.isNotEmpty == true
                ? article.images!.first
                : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _showLocationPicker,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange[200]!, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.orange[600],
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _selectedMenu ?? '지역 선택',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.orange[600],
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshArticles,
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WriteArticle()))
                .then((value) {
              setState(() {
                _refreshArticles();
              });
            });

            // final result = Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const WriteArticle()),
            // );

            // if (result == true) {
            //   _refreshArticles();
            //   print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
            //   setState(() {});
            // }
          },
          backgroundColor: Colors.orange,
          child: const Text(
            "+",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
