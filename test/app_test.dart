import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato_market/main.dart';

/// MyApp 전체 통합 테스트
///
/// 이 테스트는 앱이 정상적으로 시작되는지 확인합니다.
void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    // MyApp 위젯 빌드
    await tester.pumpWidget(const MyApp());

    // 앱이 정상적으로 렌더링되었는지 확인
    expect(tester.takeException(), isNull);

    // MaterialApp이 존재하는지 확인
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App has a Scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // 프레임이 안정될 때까지 대기
    await tester.pumpAndSettle();

    // Scaffold가 렌더링되었는지 확인
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('App navigation bar exists', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // 프레임이 안정될 때까지 대기
    await tester.pumpAndSettle();

    // BottomNavigationBar가 존재하는지 확인
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
