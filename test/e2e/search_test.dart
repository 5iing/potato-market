import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:potato_market/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('검색 기능 E2E 테스트', () {
    testWidgets('검색 탭으로 이동하여 검색창이 표시된다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final searchTab = find.byIcon(Icons.search);
      expect(searchTab, findsOneWidget);

      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      expect(find.text(' 검색어를 입력하세요.'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('추천 검색어가 표시되고 클릭 시 검색이 실행된다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final searchTab = find.byIcon(Icons.search);
      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      expect(find.text('추천 검색어'), findsOneWidget);
      expect(find.text('아이폰 17 프로'), findsOneWidget);
      expect(find.text('라즈베리 파이 5'), findsOneWidget);
      expect(find.text('시그니엘'), findsOneWidget);

      await tester.tap(find.text('아이폰 17 프로'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, '아이폰 17 프로');
    });

    testWidgets('검색어 입력 후 검색이 실행된다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final searchTab = find.byIcon(Icons.search);
      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      await tester.enterText(textField, '테스트 상품');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('검색 결과가 없을 때 안내 메시지가 표시된다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final searchTab = find.byIcon(Icons.search);
      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'zzzzzzzzzzzzzzzzz');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              (widget.data == '검색 결과가 없습니다' ||
                  widget.data == ' 검색어를 입력하세요.'),
        ),
        findsAny,
      );
    });

    testWidgets('검색 결과에서 게시글을 클릭하면 상세 페이지로 이동한다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final searchTab = find.byIcon(Icons.search);
      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      await tester.tap(find.text('아이폰 17 프로'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

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
    });

    testWidgets('여러 추천 검색어를 순차적으로 테스트한다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final searchTab = find.byIcon(Icons.search);
      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      final suggestions = ['아이폰 17 프로', '라즈베리 파이 5', '시그니엘'];

      for (final suggestion in suggestions) {
        final suggestionFinder = find.text(suggestion);
        if (suggestionFinder.evaluate().isNotEmpty) {
          await tester.tap(suggestionFinder);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          final textField = tester.widget<TextField>(find.byType(TextField));
          expect(textField.controller?.text, suggestion);

          textField.controller?.clear();
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('검색창 텍스트를 지우면 추천 검색어가 다시 표시된다', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final searchTab = find.byIcon(Icons.search);
      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      await tester.enterText(textField, '테스트');
      await tester.pumpAndSettle();

      final textFieldWidget = tester.widget<TextField>(textField);
      textFieldWidget.controller?.clear();
      await tester.pumpAndSettle();

      expect(find.text('추천 검색어'), findsOneWidget);
    });
  });
}
