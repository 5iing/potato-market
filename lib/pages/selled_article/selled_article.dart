import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../components/main_article.dart';
import '../../models/article.dart';
import '../../utils/format_utils.dart';
import '../article/article_detail.dart';
import '../../components/custom_divider.dart';

class SelledArticle extends StatefulWidget {
  const SelledArticle({Key? key}) : super(key: key);

  @override
  State<SelledArticle> createState() => _SelledArticleState();
}

class _SelledArticleState extends State<SelledArticle> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Article> _articles = [];

  Future<void> _searchLikedArticles() async {
    try {
      final articles = await _apiService.getMyArticles();

      if (articles.isEmpty) {}

      setState(() {
        _articles = articles;
        _isLoading = true;
      });
    } catch (e) {
      print('게시글 로딩 에러: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchLikedArticles();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "판매내역",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          )),
      body: Column(
        children: [
          Expanded(
              child: _articles.isEmpty && _isLoading == false
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            '아직 관심 목록이 없습니다',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _articles.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return CustomDivider();
                        }

                        final article = _articles[index - 1];

                        return InkWell(
                            onTap: () {
                              if (article.id != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ArticleDetail(
                                            articleId: article.id!)));
                              }
                            },
                            child: MainArticle(
                              productName: article.title ?? '제목 없음',
                              hometown: article.location ?? '알 수 없음',
                              price: FormatUtils.formatPrice(article.price),
                              uploadedAt:
                                  FormatUtils.formatDateTime(article.createdAt),
                              view: article.views ?? 0,
                              likeCount: article.likeCount ?? 0,
                              isReserving: article.status == 'reserved',
                              imageUrl: article.images?.isNotEmpty == true
                                  ? article.images!.first
                                  : null,
                            ));
                      }))
        ],
      ),
    );
  }
}
