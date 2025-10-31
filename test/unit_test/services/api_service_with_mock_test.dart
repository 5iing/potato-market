import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:potato_market/services/api_service.dart';
import 'dart:convert';

import 'api_service_mock_test.mocks.dart';

// Mock 클래스 자동 생성
// 터미널에서 실행: dart run build_runner build
@GenerateMocks([http.Client])
void main() {
  group('ApiService with Mock HTTP Client', () {
    late ApiService apiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);
    });

    group('getArticles', () {
      test('returns articles when HTTP call succeeds', () async {
        // Mock response (영문만 사용)
        final mockResponse = jsonEncode({
          'data': {
            'articles': [
              {
                'id': 1,
                'userId': 123,
                'title': 'iPhone 15 Pro',
                'content': 'Almost new',
                'price': 1200000,
                'category': 'Electronics',
                'location': 'Seoul',
                'images': ['/images/iphone1.jpg'],
                'status': 'active',
                'views': 50,
                'isNegotiable': true,
                'likeCount': 10,
                'isLiked': false,
                'isMe': false,
                'createdAt': '2024-01-01T10:00:00.000Z',
                'user': {
                  'id': 123,
                  'name': 'Seller',
                  'temperature': 36.5,
                }
              },
            ],
          }
        });

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(mockResponse, 200));

        final articles = await apiService.getArticles();

        expect(articles.length, 1);
        expect(articles[0].id, 1);
        expect(articles[0].title, 'iPhone 15 Pro');
        expect(articles[0].price, 1200000);
        expect(articles[0].likeCount, 10);

        verify(mockClient.get(any, headers: anyNamed('headers'))).called(1);
      });

      test('returns empty list when no articles', () async {
        final mockResponse = jsonEncode({
          'data': {'articles': []}
        });

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(mockResponse, 200));

        final articles = await apiService.getArticles();

        expect(articles, isEmpty);
      });

      test('throws exception on HTTP error', () async {
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('Server Error', 500));

        expect(() => apiService.getArticles(), throwsException);
      });

      test('sends correct pagination parameters', () async {
        final mockResponse = jsonEncode({
          'data': {'articles': []}
        });

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(mockResponse, 200));

        await apiService.getArticles(page: 2, limit: 10);

        final captured = verify(mockClient.get(
          captureAny,
          headers: anyNamed('headers'),
        )).captured;

        final uri = captured[0] as Uri;
        expect(uri.queryParameters['page'], '2');
        expect(uri.queryParameters['limit'], '10');
      });

      test('sends correct search parameters', () async {
        final mockResponse = jsonEncode({
          'data': {'articles': []}
        });

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(mockResponse, 200));

        await apiService.getArticles(
          search: 'iPhone',
          category: 'Electronics',
          location: 'Seoul',
        );

        final captured = verify(mockClient.get(
          captureAny,
          headers: anyNamed('headers'),
        )).captured;

        final uri = captured[0] as Uri;
        expect(uri.queryParameters['search'], 'iPhone');
        expect(uri.queryParameters['category'], 'Electronics');
        expect(uri.queryParameters['location'], 'Seoul');
      });
    });

    group('getArticle', () {
      test('returns single article details', () async {
        final mockResponse = jsonEncode({
          'data': {
            'id': 1,
            'title': 'iPhone 15 Pro',
            'price': 1200000,
            'content': 'Detailed description',
            'location': 'Seoul',
            'views': 100,
            'likeCount': 20,
            'isLiked': true,
          }
        });

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(mockResponse, 200));

        final article = await apiService.getArticle(1);

        expect(article.id, 1);
        expect(article.title, 'iPhone 15 Pro');
        expect(article.price, 1200000);
        expect(article.isLiked, true);
        expect(article.likeCount, 20);
      });
    });

    group('likeArticle', () {
      test('increases like count and sets isLiked to true', () async {
        final mockResponse = jsonEncode({
          'data': {
            'id': 1,
            'title': 'Test Product',
            'price': 10000,
            'likeCount': 11,
            'isLiked': true,
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

        verify(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });
    });

    group('createArticle', () {
      test('creates new article successfully', () async {
        final mockResponse = jsonEncode({
          'data': {
            'id': 999,
            'title': 'New Product',
            'content': 'Description',
            'price': 50000,
            'category': 'Electronics',
            'location': 'Busan',
            'status': 'active',
          }
        });

        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(mockResponse, 201));

        final article = await apiService.createArticle(
          title: 'New Product',
          content: 'Description',
          price: 50000,
          category: 'Electronics',
          location: 'Busan',
        );

        expect(article.id, 999);
        expect(article.title, 'New Product');
        expect(article.price, 50000);

        final captured = verify(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: captureAnyNamed('body'),
        )).captured;

        final bodyJson = jsonDecode(captured[0] as String);
        expect(bodyJson['title'], 'New Product');
        expect(bodyJson['price'], 50000);
      });
    });

    group('getUserProfile', () {
      test('returns user profile', () async {
        final mockResponse = jsonEncode({
          'data': {
            'id': 1,
            'email': 'user@example.com',
            'name': 'John Doe',
            'phone': '010-1234-5678',
            'location': 'Seoul',
            'temperature': 36.5,
          }
        });

        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(mockResponse, 200));

        final user = await apiService.getUserProfile();

        expect(user.id, 1);
        expect(user.email, 'user@example.com');
        expect(user.name, 'John Doe');
        expect(user.temperature, 36.5);
      });
    });

    group('Error Handling', () {
      test('401 Unauthorized', () async {
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('Unauthorized', 401));

        expect(() => apiService.getArticles(), throwsException);
      });

      test('404 Not Found', () async {
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() => apiService.getArticle(99999), throwsException);
      });

      test('Network timeout', () async {
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenThrow(Exception('Network Timeout'));

        expect(() => apiService.getArticles(), throwsException);
      });
    });
  });
}
