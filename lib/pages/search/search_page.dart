import 'package:flutter/material.dart';
import 'package:potato_market/components/custom_divider.dart';
import 'package:potato_market/components/main_article.dart';
import 'package:potato_market/pages/article/article_detail.dart';
import '../../services/api_service.dart';
import '../../models/article.dart';
import '../../utils/format_utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();

  final ApiService _apiService = ApiService();
  List<Article> _articles = [];

  final String suggest_one = "아이폰 17 프로";
  final String suggest_two = "라즈베리 파이 5";
  final String suggest_three = "시그니엘";

  Future<void> _searchArticles() async {
    try {
      final articles = await _apiService.getArticles(
          location: '목동동', //TODO: 하드코딩 제거
          limit: 20,
          search: controller.text);

      if (articles.isEmpty) {}

      setState(() {
        _articles = articles;
      });
    } catch (e) {
      print('게시글 로딩 에러: $e');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        body: Column(children: [
      SizedBox(
        height: 70,
      ),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: " 검색어를 입력하세요.",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) => setState(() {
                    _searchArticles();
                  }),
                  controller: controller,
                ),
              ),
            ),
          )
        ],
      ),
      controller.text.isEmpty
          ? Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "추천 검색어",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            )
          : SizedBox(
              height: 0,
            ),
      controller.text.isEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              child: Text(suggest_one),
                              onTap: () {
                                setState(() {
                                  controller.text = suggest_one;
                                  _searchArticles();
                                });
                              }),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              child: Text(suggest_two),
                              onTap: () {
                                setState(() {
                                  controller.text = suggest_two;
                                  _searchArticles();
                                });
                              }),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              child: Text(suggest_three),
                              onTap: () {
                                setState(() {
                                  controller.text = suggest_three;
                                  _searchArticles();
                                });
                              }),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          : Expanded(
              child: _articles.isEmpty && controller.text.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            '검색 결과가 없습니다',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
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
    ]));
  }
}
