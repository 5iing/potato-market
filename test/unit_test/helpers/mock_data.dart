import 'package:potato_market/models/article.dart';
import 'package:potato_market/models/user.dart';

/// 테스트용 목 데이터 생성 헬퍼 클래스
class MockData {
  /// 기본 User 목 데이터 생성
  static User createMockUser({
    int id = 1,
    String email = 'test@example.com',
    String name = '테스트유저',
    String? phone = '010-1234-5678',
    String? profileImage,
    String location = '서울시 강남구',
    double temperature = 36.5,
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      phone: phone,
      profileImage: profileImage,
      location: location,
      temperature: temperature,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  /// 기본 Article 목 데이터 생성
  static Article createMockArticle({
    int id = 1,
    int userId = 1,
    String title = '테스트 상품',
    String content = '테스트 상품 설명입니다',
    int price = 10000,
    String category = '전자기기',
    String location = '서울시 강남구',
    List<String>? images,
    String status = 'active',
    int views = 0,
    bool isNegotiable = false,
    User? user,
    int likeCount = 0,
    bool isLiked = false,
    bool isMe = false,
  }) {
    return Article(
      id: id,
      userId: userId,
      title: title,
      content: content,
      price: price,
      category: category,
      location: location,
      images: images,
      status: status,
      views: views,
      isNegotiable: isNegotiable,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      updatedAt: DateTime.now(),
      user: user ?? createMockUser(id: userId),
      likeCount: likeCount,
      isLiked: isLiked,
      isMe: isMe,
    );
  }

  /// 여러 Article 목록 생성
  static List<Article> createMockArticles(int count) {
    return List.generate(
      count,
      (index) => createMockArticle(
        id: index + 1,
        userId: index + 1,
        title: '테스트 상품 ${index + 1}',
        price: (index + 1) * 10000,
        views: index * 10,
        likeCount: index * 2,
      ),
    );
  }

  /// 이미지가 있는 Article 생성
  static Article createMockArticleWithImages({
    int imageCount = 3,
  }) {
    return createMockArticle(
      title: '이미지 있는 상품',
      images: List.generate(
        imageCount,
        (index) => '/images/test_${index + 1}.jpg',
      ),
    );
  }

  /// 좋아요가 많은 인기 Article 생성
  static Article createPopularArticle() {
    return createMockArticle(
      title: '인기 상품',
      price: 500000,
      views: 9999,
      likeCount: 888,
      isLiked: true,
    );
  }

  /// 내가 작성한 Article 생성
  static Article createMyArticle() {
    return createMockArticle(
      title: '내가 올린 상품',
      isMe: true,
      user: createMockUser(
        name: '나',
        email: 'me@example.com',
      ),
    );
  }

  /// 예약중인 Article 생성
  static Article createReservedArticle() {
    return createMockArticle(
      title: '예약중인 상품',
      status: 'reserved',
    );
  }

  /// 판매완료된 Article 생성
  static Article createSoldArticle() {
    return createMockArticle(
      title: '판매완료 상품',
      status: 'sold',
    );
  }

  /// JSON 형식의 Article 응답 데이터
  static Map<String, dynamic> mockArticleJsonResponse({
    int count = 1,
    bool includeData = true,
  }) {
    final articles = createMockArticles(count)
        .map((article) => article.toJson())
        .toList();

    if (includeData) {
      return {
        'data': {
          'articles': articles,
          'total': count,
          'page': 1,
          'limit': 20,
        }
      };
    } else {
      return {'articles': articles};
    }
  }

  /// JSON 형식의 단일 Article 응답 데이터
  static Map<String, dynamic> mockSingleArticleJsonResponse({
    Article? article,
    bool includeData = true,
  }) {
    final articleData =
        (article ?? createMockArticle()).toJson();

    if (includeData) {
      return {'data': articleData};
    } else {
      return articleData;
    }
  }

  /// JSON 형식의 User 응답 데이터
  static Map<String, dynamic> mockUserJsonResponse({
    User? user,
    bool includeData = true,
  }) {
    final userData = (user ?? createMockUser()).toJson();

    if (includeData) {
      return {'data': userData};
    } else {
      return userData;
    }
  }

  /// 빈 목록 응답
  static Map<String, dynamic> mockEmptyArticlesResponse() {
    return {
      'data': {
        'articles': [],
        'total': 0,
        'page': 1,
        'limit': 20,
      }
    };
  }

  /// 에러 응답
  static Map<String, dynamic> mockErrorResponse({
    String message = '에러가 발생했습니다',
    int statusCode = 400,
  }) {
    return {
      'error': message,
      'statusCode': statusCode,
    };
  }

  /// 카테고리별 Article 목록 생성
  static List<Article> createMockArticlesByCategory(
    String category,
    int count,
  ) {
    return List.generate(
      count,
      (index) => createMockArticle(
        id: index + 1,
        title: '$category 상품 ${index + 1}',
        category: category,
      ),
    );
  }

  /// 가격대별 Article 생성
  static Article createMockArticleByPrice(int price) {
    String priceRange;
    if (price < 10000) {
      priceRange = '저가';
    } else if (price < 100000) {
      priceRange = '중가';
    } else {
      priceRange = '고가';
    }

    return createMockArticle(
      title: '$priceRange 상품',
      price: price,
    );
  }

  /// 다양한 상태의 Article 목록 생성
  static List<Article> createMockArticlesWithVariousStatus() {
    return [
      createMockArticle(id: 1, title: '활성 상품', status: 'active'),
      createReservedArticle().copyWith(id: 2),
      createSoldArticle().copyWith(id: 3),
    ];
  }
}

/// Article 확장 메서드 - copyWith 패턴
extension ArticleCopyWith on Article {
  Article copyWith({
    int? id,
    int? userId,
    String? title,
    String? content,
    int? price,
    String? category,
    String? location,
    List<String>? images,
    String? status,
    int? views,
    bool? isNegotiable,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
    int? likeCount,
    bool? isLiked,
    bool? isMe,
  }) {
    return Article(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      price: price ?? this.price,
      category: category ?? this.category,
      location: location ?? this.location,
      images: images ?? this.images,
      status: status ?? this.status,
      views: views ?? this.views,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isMe: isMe ?? this.isMe,
    );
  }
}
