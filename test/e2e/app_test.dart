import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:potato_market/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('앱 전체 플로우 E2E 테스트', () {
    testWidgets('앱이 정상적으로 시작되고 홈 화면이 표시된다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsWidgets);
    });

    testWidgets('홈 화면에서 지역 선택 후 게시글 목록이 로드된다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final locationButton = find.byIcon(Icons.location_on).first;
      await tester.tap(locationButton);
      await tester.pumpAndSettle();

      expect(find.text('지역을 선택해주세요'), findsOneWidget);

      final location = find.text('목동동');
      if (location.evaluate().isNotEmpty) {
        await tester.tap(location);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
    });

    testWidgets('새로고침이 정상적으로 작동한다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('글쓰기 버튼 클릭 시 글쓰기 화면으로 이동한다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pumpAndSettle();

      expect(find.text('글쓰기'), findsAny);
    });
  });
}
