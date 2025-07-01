import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final String ISBN;

  const WebViewPage({Key? key, required this.ISBN}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebView')),
      body: Center(child: WebViewBody(ISBN: ISBN)),
    );
  }
}

String convertISBN(String isbn13) {
  // ISBN-13の形式チェック（978または979で始まる13桁）
  if (isbn13.length != 13 ||
      (!isbn13.startsWith('978') && !isbn13.startsWith('979'))) {
    throw Exception("ISBN-13の形式が正しくありません。");
  }

  // 978で始まるISBN-13のみISBN-10に変換可能
  if (!isbn13.startsWith('978')) {
    throw Exception("ISBN-13は979で始まるため、変換できません。");
  }

  // 978プレフィックスを除去して最初の9桁を取得
  String isbn10Base = isbn13.substring(3, 12);

  // チェックディジットを計算
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += int.parse(isbn10Base[i]) * (10 - i);
  }

  int checkDigit = (11 - (sum % 11)) % 11;
  String checkChar = checkDigit == 10 ? 'X' : checkDigit.toString();

  return isbn10Base + checkChar;
}

class WebViewBody extends StatelessWidget {
  final String ISBN;

  @override
  WebViewBody({Key? key, required this.ISBN}) : super(key: key);
  Widget build(BuildContext context) {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://www.amazon.co.jp/dp/${convertISBN(ISBN)}'),
      );
    return WebViewWidget(controller: controller);
  }
}
