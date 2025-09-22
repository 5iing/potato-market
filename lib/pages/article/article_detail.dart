import 'package:flutter/material.dart';
import 'package:potato_market/components/buy_bottom_bar.dart';

class ArticleDetail extends StatefulWidget {
  final String authorName;
  final String authorTemprature;
  final String hometown;
  final String productName;
  final String price;
  final String category; //TODO: make this constant(enum)
  final String description;
  final String hopedTradeLocation;

  const ArticleDetail(
      {super.key,
      required this.authorName,
      required this.authorTemprature,
      required this.hometown,
      required this.productName,
      required this.price,
      required this.category,
      required this.description,
      required this.hopedTradeLocation});

  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _images = [
    'lib/assets/download.jpeg',
    'lib/assets/switch.jpeg',
  ];

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        bottomNavigationBar:
            BuyBottomBar(price: '12, 000', isNegotiation: false),
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
                      if (_images[index].isEmpty) {
                        return Container(
                          color: Colors.blue[200],
                          child: const Center(
                            child: Text('이미지 불러오기 실패',
                                style: TextStyle(fontSize: 24)),
                          ),
                        );
                      }
                      return Image.asset(
                        _images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child:
                                const Icon(Icons.image_not_supported, size: 50),
                          );
                        },
                      );
                    },
                  ),
                ),
                // 상단 네비게이션 바
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.all(20),
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
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                print('뒤로가기 버튼 클릭됨!'); // 디버그용
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(Icons.arrow_back,
                                    color: Colors.white, size: 28),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => print('공유하기'),
                                child: const Icon(Icons.share,
                                    color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 15),
                              GestureDetector(
                                onTap: () => print('메뉴'),
                                child: const Icon(Icons.more_vert,
                                    color: Colors.white, size: 24),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // 페이지 인디케이터
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
                              Text('아아아아',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                              Text('목동동', style: TextStyle(fontSize: 12))
                            ]),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('59.5'),
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
                        "참숯 판매",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "생활/가공식품  3분 전",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w200),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ"),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "관심 1 조회 294",
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
