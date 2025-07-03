import 'package:counter_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("[正常]Count: 0が表示されるテスト", (WidgetTester tester) async {
    await tester.pumpWidget(const CounterApp());
    expect(find.text('Count: 0'), findsOneWidget);
  });
  testWidgets("[正常]+1ボタンを押すとCountが1になるテスト", (WidgetTester tester) async {
    // ウィジェットをテスト用にビルド
    await tester.pumpWidget(const CounterApp());

    // ボタンを押す前にCountが0であることを確認
    expect(find.text('Count: 0'), findsOneWidget);

    // ボタンを押す
    await tester.tap(find.byKey(const Key('incrementButton')));

    // ウィジェットを再ビルドして状態を更新
    await tester.pump();

    // ボタンを押した後にCountが1になっていることを確認
    expect(find.text('Count: 1'), findsOneWidget);
  });
}
