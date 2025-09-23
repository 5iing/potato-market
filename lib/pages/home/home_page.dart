import 'package:flutter/material.dart';
import 'package:potato_market/pages/article/article_detail.dart';
import 'package:potato_market/pages/write_article/write_article.dart';
import '../../components/main_article.dart';
import '../../services/api_service.dart';
import '../../models/article.dart';
import '../../utils/format_utils.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedMenu = _dropdownMenus[0];
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

  Future<void> _refreshArticles() async {
    await _loadArticles();
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
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
        return GestureDetector(
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
          child: MainArticle(
            productName: article.title ?? '제목 없음',
            hometown: article.location ?? '알 수 없음',
            price: FormatUtils.formatPrice(article.price),
            uploadedAt: FormatUtils.formatDateTime(article.createdAt),
            isReserving: article.status == 'reserved',
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
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                child: DropdownButton<String>(
                  value: _selectedMenu,
                  hint: const Text(
                    '지역 선택',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  dropdownColor: Colors.white.withOpacity(0.9),
                  elevation: 0,
                  underline: Container(),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                    size: 30,
                  ),
                  items: _dropdownMenus.map((String menu) {
                    return DropdownMenuItem<String>(
                      value: menu,
                      child: Text(
                        menu,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedMenu = value;
                    });
                    _loadArticles(); // 지역 변경 시 게시글 다시 로딩
                  },
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black87,
                    size: 24,
                  ),
                  onPressed: () {
                    print('검색 클릭!');
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black87,
                    size: 24,
                  ),
                  onPressed: () {
                    print('메뉴 클릭');
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.black87,
                    size: 24,
                  ),
                  onPressed: () {
                    print('알림 클릭!');
                  },
                ),
              ],
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WriteArticle()),
            );
          },
          backgroundColor: Colors.orange,
          child: Text(
            "+",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
