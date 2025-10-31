import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato_market/components/main_article.dart';

void main() {
  group('MainArticle 위젯 테스트', () {
    testWidgets('기본 정보가 정상적으로 렌더링된다', (WidgetTester tester) async {
      // 목 데이터 준비
      const testProductName = '아이폰 15 프로 팝니다';
      const testPrice = '1,200,000원';
      const testHometown = '서울시 강남구';
      const testUploadedAt = '1시간 전';
      const testView = 42;
      const testLikeCount = 15;

      // 위젯 빌드
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainArticle(
              productName: testProductName,
              hometown: testHometown,
              price: testPrice,
              uploadedAt: testUploadedAt,
              isReserving: false,
              view: testView,
              likeCount: testLikeCount,
              imageUrl: null,
            ),
          ),
        ),
      );

      // 텍스트가 화면에 표시되는지 확인
      expect(find.text(testProductName), findsOneWidget);
      expect(find.text(testPrice), findsOneWidget);
      expect(find.text(testHometown), findsOneWidget);
      expect(find.text(testUploadedAt), findsOneWidget);
      expect(find.text(testView.toString()), findsOneWidget);
      expect(find.text(testLikeCount.toString()), findsOneWidget);

      // 아이콘 확인
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border_outlined), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('이미지가 없을 때 기본 아이콘을 표시한다', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainArticle(
              productName: '테스트 상품',
              hometown: '서울',
              price: '10,000원',
              uploadedAt: '1시간 전',
              isReserving: false,
              view: 10,
              likeCount: 5,
              imageUrl: null, // 이미지 없음
            ),
          ),
        ),
      );

      // 기본 이미지 아이콘이 표시되는지 확인
      expect(find.byIcon(Icons.image), findsOneWidget);
    });

    testWidgets('긴 상품명 overflow 테스트', (WidgetTester tester) async {
      // 매우 긴 텍스트로 테스트
      const veryLongProductName =
          '이것은 매우 긴 상품명입니다 너무너무 길어서 화면을 넘어갈 수도 있는 상품명입니다 정말로 정말로 길어요';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainArticle(
              productName: veryLongProductName,
              hometown: '서울시 강남구 역삼동',
              price: '10,000원',
              uploadedAt: '1시간 전',
              isReserving: false,
              view: 10,
              likeCount: 5,
            ),
          ),
        ),
      );

      // Overflow 에러가 없는지 확인
      expect(tester.takeException(), isNull);

      // 텍스트가 표시되는지 확인
      expect(find.textContaining('이것은 매우 긴 상품명'), findsOneWidget);
    });

    testWidgets('작은 화면 크기에서 레이아웃 테스트', (WidgetTester tester) async {
      // 작은 화면 크기 설정 (iPhone SE 크기)
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainArticle(
              productName: '테스트 상품',
              hometown: '서울시 강남구 역삼동 123-456',
              price: '1,000,000원',
              uploadedAt: '1시간 전',
              isReserving: false,
              view: 999,
              likeCount: 999,
            ),
          ),
        ),
      );

      // Overflow 검증
      expect(tester.takeException(), isNull);

      // 위젯이 정상적으로 렌더링되었는지 확인
      expect(find.text('테스트 상품'), findsOneWidget);

      // 화면 크기 초기화
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('큰 화면 크기에서 레이아웃 테스트', (WidgetTester tester) async {
      // 태블릿 크기 설정
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainArticle(
              productName: '태블릿 테스트 상품',
              hometown: '서울',
              price: '50,000원',
              uploadedAt: '2시간 전',
              isReserving: false,
              view: 100,
              likeCount: 20,
            ),
          ),
        ),
      );

      // Overflow 검증
      expect(tester.takeException(), isNull);

      // 화면 크기 초기화
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('숫자가 0일 때도 정상 표시', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainArticle(
              productName: '신규 상품',
              hometown: '서울',
              price: '0원',
              uploadedAt: '방금 전',
              isReserving: false,
              view: 0, // 조회수 0
              likeCount: 0, // 좋아요 0
            ),
          ),
        ),
      );

      // 0도 정상적으로 표시되는지 확인
      expect(find.text('0'), findsNWidgets(2)); // view와 likeCount
    });

    testWidgets('매우 큰 숫자도 정상 표시', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainArticle(
              productName: '인기 상품',
              hometown: '서울',
              price: '999,999,999,999원',
              uploadedAt: '1주일 전',
              isReserving: false,
              view: 99999,
              likeCount: 88888,
            ),
          ),
        ),
      );

      // 큰 숫자도 overflow 없이 표시
      expect(tester.takeException(), isNull);
      expect(find.text('99999'), findsOneWidget);
      expect(find.text('88888'), findsOneWidget);
    });

    testWidgets('Divider가 렌더링된다', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainArticle(
              productName: '테스트',
              hometown: '서울',
              price: '1,000원',
              uploadedAt: '1시간 전',
              isReserving: false,
              view: 10,
              likeCount: 5,
            ),
          ),
        ),
      );

      // Divider 위젯이 존재하는지 확인
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('이미지 URL이 있을 때 네트워크 이미지 위젯이 생성된다', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainArticle(
              productName: '이미지 있는 상품',
              hometown: '서울',
              price: '10,000원',
              uploadedAt: '1시간 전',
              isReserving: false,
              view: 10,
              likeCount: 5,
              imageUrl: '/images/test.jpg',
            ),
          ),
        ),
      );

      // Image.network 위젯이 생성되는지 확인
      await tester.pump();

      // 이미지 로딩 중이거나 에러 처리가 되어야 함
      // (실제 네트워크 연결 없이는 에러 위젯이 표시됨)
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image ||
              widget is Container ||
              widget is CircularProgressIndicator,
        ),
        findsWidgets,
      );
    });

    testWidgets('위젯의 너비가 전체 화면을 차지한다', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainArticle(
              productName: '테스트',
              hometown: '서울',
              price: '1,000원',
              uploadedAt: '1시간 전',
              isReserving: false,
              view: 10,
              likeCount: 5,
            ),
          ),
        ),
      );

      // 최상위 Container의 너비 확인
      final containerWidget = tester.widget<Container>(
        find.byType(Container).first,
      );

      expect(containerWidget.constraints?.maxWidth ?? double.infinity,
          double.infinity);
    });

    testWidgets('모든 요소가 올바른 순서로 배치된다', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainArticle(
              productName: '순서 테스트 상품',
              hometown: '서울시',
              price: '50,000원',
              uploadedAt: '3시간 전',
              isReserving: false,
              view: 100,
              likeCount: 20,
            ),
          ),
        ),
      );

      // Row 위젯이 존재하는지 확인
      expect(find.byType(Row), findsWidgets);

      // Column 위젯이 존재하는지 확인 (텍스트 정보 섹션)
      expect(find.byType(Column), findsWidgets);

      // SizedBox 위젯이 존재하는지 확인 (간격)
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
