import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:potato_market/services/api_service.dart';
import 'package:potato_market/models/article.dart';
import 'package:potato_market/models/user.dart';
import 'dart:convert';

import 'api_service_mock_test.mocks.dart';

// Mock 클래스 자동 생성
// 터미널에서 실행: dart run build_runner build
@GenerateMocks([http.Client])
void main() {
  group('ApiService Mock 테스트', () {
    late ApiService apiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);
    });

    group('getArticles - 게시글 목록 조회', () {
      test('성공: 게시글 목록을 올바르게 파싱한다', () async {
        // 목 응답 데이터
        final mockResponse = jsonEncode({
          'data': {
            'articles': [
              {
                'id': 1,
                'userId': 123,
                'title': '아이폰 15 프로',
                'content': '거의 새 제품입니다',
                'price': 1200000,
                'category': '전자기기',
                'location': '서울시 강남구',
                'images': ['/images/iphone1.jpg'],
                'status': 'active',
                'views': 50,
                'isNegotiable': true,
                'likeCount': 10,
                'isLiked': false,
                'isMe': false,
                'createdAt': '2024-01-01T10:00:00.000Z',
                'updatedAt': '2024-01-02T10:00:00.000Z',
                'user': {
                  'id': 123,
                  'email': 'seller@example.com',
                  'name': '판매자',
                  'location': '서울시 강남구',
                  'temperature': 36.5,
                }
              },
              {
                'id': 2,
                'userId': 124,
                'title': '맥북 프로',
                'content': 'M3 칩 탑재',
                'price': 2500000,
                'category': '전자기기',
                'location': '서울시 종로구',
                'status': 'active',
                'views': 100,
                'likeCount': 25,
                'createdAt': '2024-01-03T10:00:00.000Z',
              }
            ],
            'total': 2,
            'page': 1,
            'limit': 20
          }
        });

        // Mock HTTP 응답 설정 (UTF-8 인코딩 사용)
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
              mockResponse,
              200,
              headers: {'content-type': 'application/json; charset=utf-8'},
            ));

        // 실제 테스트 실행
        final articles = await apiService.getArticles();

        // 검증
        expect(articles.length, 2);
        expect(articles[0].id, 1);
        expect(articles[0].title, '아이폰 15 프로');
        expect(articles[0].price, 1200000);
        expect(articles[0].likeCount, 10);
        expect(articles[0].user?.name, '판매자');

        expect(articles[1].id, 2);
        expect(articles[1].title, '맥북 프로');
        expect(articles[1].price, 2500000);

        // HTTP 요청이 한 번 호출되었는지 확인
        verify(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).called(1);
      });

      test('성공: 빈 목록을 올바르게 처리한다', () async {
        final mockResponse = jsonEncode({
          'data': {
            'articles': [],
            'total': 0,
            'page': 1,
            'limit': 20
          }
        });

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(mockResponse, 200));

        final articles = await apiService.getArticles();

        expect(articles, isEmpty);
      });

      test('실패: 네트워크 에러 발생', () async {
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

        expect(
          () => apiService.getArticles(),
          throwsException,
        );
      });

      test('성공: 페이지네이션 파라미터가 올바르게 전달된다', () async {
        final mockResponse = jsonEncode({
          'data': {'articles': []}
        });

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(mockResponse, 200));

        await apiService.getArticles(page: 2, limit: 10);

        // URL에 페이지네이션 파라미터가 포함되었는지 확인
        final captured = verify(mockClient.get(
          captureAny,
          headers: anyNamed('headers'),
        )).captured;

        final uri = captured[0] as Uri;
        expect(uri.queryParameters['page'], '2');
        expect(uri.queryParameters['limit'], '10');
      });

      test('성공: 검색 파라미터가 올바르게 전달된다', () async {
        final mockResponse = jsonEncode({
          'data': {'articles': []}
        });

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(mockResponse, 200));

        await apiService.getArticles(
          search: '아이폰',
          category: '전자기기',
          location: '서울',
        );

        final captured = verify(mockClient.get(
          captureAny,
          headers: anyNamed('headers'),
        )).captured;

        final uri = captured[0] as Uri;
        expect(uri.queryParameters['search'], '아이폰');
        expect(uri.queryParameters['category'], '전자기기');
        expect(uri.queryParameters['location'], '서울');
      });
    });

    group('getArticle - 게시글 단일 조회', () {
      test('성공: 게시글 상세 정보를 조회한다', () async {
        final mockResponse = jsonEncode({
          'data': {
            'id': 1,
            'title': '아이폰 15 프로',
            'price': 1200000,
            'content': '상세 설명입니다',
            'location': '서울',
            'views': 100,
            'likeCount': 20,
            'isLiked': true,
            'user': {
              'id': 123,
              'name': '판매자',
              'temperature': 36.5,
            }
          }
        });

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(mockResponse, 200));

        final article = await apiService.getArticle(1);

        expect(article.id, 1);
        expect(article.title, '아이폰 15 프로');
        expect(article.price, 1200000);
        expect(article.isLiked, true);
        expect(article.likeCount, 20);
      });
    });

    group('likeArticle - 게시글 좋아요', () {
      test('성공: 게시글에 좋아요를 누른다', () async {
        final mockResponse = jsonEncode({
          'data': {
            'id': 1,
            'title': '테스트 상품',
            'price': 10000,
            'likeCount': 11, // 좋아요 +1
            'isLiked': true, // 좋아요 상태로 변경
          }
        });

        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(mockResponse, 200));

        final article = await apiService.likeArticle(id: 1);

        expect(article.likeCount, 11);
        expect(article.isLiked, true);
      });
    });

    group('createArticle - 게시글 작성', () {
      test('성공: 새 게시글을 작성한다', () async {
        final mockResponse = jsonEncode({
          'data': {
            'id': 999,
            'title': '새 상품',
            'content': '새 상품 설명',
            'price': 50000,
            'category': '가전제품',
            'location': '부산',
            'status': 'active',
            'createdAt': '2024-01-10T10:00:00.000Z',
          }
        });

        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(mockResponse, 201));

        final article = await apiService.createArticle(
          title: '새 상품',
          content: '새 상품 설명',
          price: 50000,
          category: '가전제품',
          location: '부산',
        );

        expect(article.id, 999);
        expect(article.title, '새 상품');
        expect(article.price, 50000);

        // POST 요청의 body 내용 확인
        final captured = verify(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: captureAnyNamed('body'),
        )).captured;

        final bodyJson = jsonDecode(captured[0] as String);
        expect(bodyJson['title'], '새 상품');
        expect(bodyJson['price'], 50000);
      });
    });

    group('getUserProfile - 사용자 프로필 조회', () {
      test('성공: 사용자 프로필을 조회한다', () async {
        final mockResponse = jsonEncode({
          'data': {
            'id': 1,
            'email': 'user@example.com',
            'name': '홍길동',
            'phone': '010-1234-5678',
            'location': '서울시 강남구',
            'temperature': 36.5,
            'profileImage': '/images/profile.jpg',
          }
        });

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(mockResponse, 200));

        final user = await apiService.getUserProfile();

        expect(user.id, 1);
        expect(user.email, 'user@example.com');
        expect(user.name, '홍길동');
        expect(user.temperature, 36.5);
      });
    });

    group('에러 처리 테스트', () {
      test('401 Unauthorized - 인증 에러', () async {
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('Unauthorized', 401));

        expect(
          () => apiService.getArticles(),
          throwsException,
        );
      });

      test('404 Not Found - 리소스 없음', () async {
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(
          () => apiService.getArticle(99999),
          throwsException,
        );
      });

      test('네트워크 타임아웃 에러', () async {
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenThrow(Exception('Network Timeout'));

        expect(
          () => apiService.getArticles(),
          throwsException,
        );
      });
    });
  });
}
