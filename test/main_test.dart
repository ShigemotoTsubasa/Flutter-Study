import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("[正常]アプリの正常起動", (WidgetTester tester) async {
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return MaterialApp(home: MyHomePage());
        },
      ),
    );
  });

  testWidgets("[正常]バーコードリストが空の状態で表示", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));
    expect(find.text('バーコードをスキャンしてください'), findsOneWidget);
  });
}
