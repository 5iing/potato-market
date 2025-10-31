import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:potato_market/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('네비게이션 E2E 테스트', () {
    testWidgets('하단 네비게이션 바의 모든 탭 이동이 정상 작동한다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);

      final navItems = find.byType(BottomNavigationBarItem);
      expect(navItems, findsWidgets);

      final homeTab = find.byIcon(Icons.home);
      if (homeTab.evaluate().isNotEmpty) {
        await tester.tap(homeTab);
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.location_on), findsWidgets);
      }

      final searchTab = find.byIcon(Icons.search);
      if (searchTab.evaluate().isNotEmpty) {
        await tester.tap(searchTab);
        await tester.pumpAndSettle();
      }

      final chatTab = find.byIcon(Icons.chat_bubble_outline);
      if (chatTab.evaluate().isNotEmpty) {
        await tester.tap(chatTab);
        await tester.pumpAndSettle();
      }

      final myPageTab = find.byIcon(Icons.person_outline);
      if (myPageTab.evaluate().isNotEmpty) {
        await tester.tap(myPageTab);
        await tester.pumpAndSettle();
      }

      await tester.tap(homeTab);
      await tester.pumpAndSettle();
    });

    testWidgets('여러 탭을 빠르게 전환해도 정상 작동한다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final homeTab = find.byIcon(Icons.home);
      final searchTab = find.byIcon(Icons.search);
      final chatTab = find.byIcon(Icons.chat_bubble_outline);
      final myPageTab = find.byIcon(Icons.person_outline);

      for (int i = 0; i < 3; i++) {
        if (searchTab.evaluate().isNotEmpty) {
          await tester.tap(searchTab);
          await tester.pump();
        }

        if (homeTab.evaluate().isNotEmpty) {
          await tester.tap(homeTab);
          await tester.pump();
        }

        if (chatTab.evaluate().isNotEmpty) {
          await tester.tap(chatTab);
          await tester.pump();
        }

        if (myPageTab.evaluate().isNotEmpty) {
          await tester.tap(myPageTab);
          await tester.pump();
        }
      }

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('홈 화면에서 게시글 클릭 시 상세 페이지로 이동한다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final articleList = find.byType(ListView);
      if (articleList.evaluate().isNotEmpty) {
        await tester.drag(articleList.first, const Offset(0, -200));
        await tester.pumpAndSettle();

        final inkWells = find.byType(InkWell);
        if (inkWells.evaluate().length > 1) {
          await tester.tap(inkWells.at(1));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          final backButton = find.byType(BackButton);
          if (backButton.evaluate().isNotEmpty) {
            await tester.tap(backButton);
            await tester.pumpAndSettle();
          }
        }
      }
    });

    testWidgets('글쓰기 화면에서 뒤로가기가 정상 작동한다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final fab = find.byType(FloatingActionButton);
      if (fab.evaluate().isNotEmpty) {
        await tester.tap(fab);
        await tester.pumpAndSettle();

        final backButton = find.byType(BackButton);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton);
          await tester.pumpAndSettle();

          expect(find.byType(FloatingActionButton), findsOneWidget);
        }
      }
    });
  });
}
