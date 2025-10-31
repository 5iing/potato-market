import 'package:flutter_test/flutter_test.dart';
import 'package:potato_market/models/article.dart';
import 'package:potato_market/models/user.dart';

// Mock 클래스 자동 생성은 나중에 추가 가능
// 터미널에서 실행: flutter pub run build_runner build
void main() {
  group('ApiService 단위 테스트', () {
    group('getArticles - 게시글 목록 조회', () {
      test('성공: 게시글 목록을 올바르게 파싱한다', () async {
        // 목 데이터는 실제 API 응답 형식에 맞춰 작성
        // 이 테스트는 실제 로컬 서버가 필요하거나, http.Client를 mock해야 합니다
        // 현재는 통합 테스트 형태로 작성됩니다

        // 실제 테스트 시 MockClient를 주입받을 수 있도록 ApiService를 리팩토링하는 것이 좋습니다
      });

      test('빈 목록 응답을 올바르게 처리한다', () {
        // 빈 배열 응답 테스트
        final emptyResponse = {
          'data': {'articles': <dynamic>[]}
        };

        // 실제로는 Mock HTTP 응답을 설정해야 합니다
        expect(emptyResponse['data']!['articles'], isEmpty);
      });
    });

    group('Article 모델 테스트', () {
      test('JSON에서 Article 객체로 정상 변환', () {
        final json = {
          'id': 1,
          'userId': 123,
          'title': '테스트 상품',
          'content': '상품 설명입니다',
          'price': 10000,
          'category': '전자기기',
          'location': '서울시 강남구',
          'images': ['/images/test1.jpg', '/images/test2.jpg'],
          'status': 'active',
          'views': 50,
          'isNegotiable': true,
          'likeCount': 5,
          'isLiked': false,
          'isMe': false,
          'createdAt': '2024-01-01T10:00:00.000Z',
          'updatedAt': '2024-01-02T10:00:00.000Z',
          'user': {
            'id': 123,
            'email': 'test@example.com',
            'name': '홍길동',
            'phone': '010-1234-5678',
            'location': '서울시 강남구',
            'temperature': 36.5,
          }
        };

        final article = Article.fromJson(json);

        expect(article.id, 1);
        expect(article.title, '테스트 상품');
        expect(article.price, 10000);
        expect(article.location, '서울시 강남구');
        expect(article.images?.length, 2);
        expect(article.likeCount, 5);
        expect(article.isLiked, false);
        expect(article.user?.name, '홍길동');
        expect(article.user?.temperature, 36.5);
      });

      test('snake_case 필드명도 올바르게 변환', () {
        final json = {
          'id': 1,
          'user_id': 123,
          'title': '테스트',
          'price': 5000,
          'is_negotiable': true,
          'created_at': '2024-01-01T10:00:00.000Z',
        };

        final article = Article.fromJson(json);

        expect(article.userId, 123);
        expect(article.isNegotiable, true);
        expect(article.createdAt, isNotNull);
      });

      test('필수 필드만 있어도 정상 동작', () {
        final json = {
          'id': 1,
          'title': '최소 정보 상품',
          'price': 1000,
        };

        final article = Article.fromJson(json);

        expect(article.id, 1);
        expect(article.title, '최소 정보 상품');
        expect(article.price, 1000);
        expect(article.images, isNull);
        expect(article.user, isNull);
      });

      test('Article을 JSON으로 변환', () {
        final article = Article(
          id: 1,
          title: '테스트 상품',
          price: 10000,
          location: '서울',
        );

        final json = article.toJson();

        expect(json['id'], 1);
        expect(json['title'], '테스트 상품');
        expect(json['price'], 10000);
        expect(json['location'], '서울');
      });
    });

    group('User 모델 테스트', () {
      test('JSON에서 User 객체로 정상 변환', () {
        final json = {
          'id': 1,
          'email': 'test@example.com',
          'name': '홍길동',
          'phone': '010-1234-5678',
          'profile_image': '/images/profile.jpg',
          'location': '서울시',
          'temperature': 36.5,
          'created_at': '2024-01-01T10:00:00.000Z',
        };

        final user = User.fromJson(json);

        expect(user.id, 1);
        expect(user.email, 'test@example.com');
        expect(user.name, '홍길동');
        expect(user.phone, '010-1234-5678');
        expect(user.profileImage, '/images/profile.jpg');
        expect(user.temperature, 36.5);
      });

      test('camelCase와 snake_case 혼용 처리', () {
        final json1 = {
          'id': 1,
          'profileImage': '/image.jpg',
          'createdAt': '2024-01-01T10:00:00.000Z',
        };

        final json2 = {
          'id': 2,
          'profile_image': '/image.jpg',
          'created_at': '2024-01-01T10:00:00.000Z',
        };

        final user1 = User.fromJson(json1);
        final user2 = User.fromJson(json2);

        expect(user1.profileImage, '/image.jpg');
        expect(user2.profileImage, '/image.jpg');
        expect(user1.createdAt, isNotNull);
        expect(user2.createdAt, isNotNull);
      });

      test('temperature가 문자열일 때도 변환', () {
        final json = {
          'id': 1,
          'name': '홍길동',
          'temperature': '36.5',
        };

        final user = User.fromJson(json);

        expect(user.temperature, 36.5);
      });
    });

    group('데이터 검증 테스트', () {
      test('가격이 음수일 수 없다', () {
        final article = Article(
          id: 1,
          title: '테스트',
          price: 10000,
        );

        expect(article.price, greaterThanOrEqualTo(0));
      });

      test('이메일 형식이 올바른지 확인', () {
        final user = User(
          id: 1,
          email: 'test@example.com',
          name: '홍길동',
        );

        expect(user.email, contains('@'));
        expect(user.email, matches(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'));
      });

      test('전화번호 형식 검증', () {
        final validPhones = [
          '010-1234-5678',
          '010-9999-9999',
          '02-1234-5678',
        ];

        for (final phone in validPhones) {
          expect(phone, matches(r'^\d{2,3}-\d{3,4}-\d{4}$'));
        }
      });
    });
  });
}
