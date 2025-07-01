import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/WebViewPage.dart';

void main() {
  test("[正常]ISBN13からISBN10に変換", () {
    expect(convertISBN('9781234567890'), '123456789X');
  });

  test("[正常]別のISBN13をISBN10に変換", () {
    expect(convertISBN('9780306406157'), '0306406152');
  });

  test("[異常]ISBNでない数値を変換しようとすると例外", () {
    expect(() => convertISBN('1234567890123'), throwsException);
  });

  test("[異常]979で始まるISBN13は変換できない", () {
    expect(() => convertISBN('9791234567890'), throwsException);
  });

  test("[異常]convertISBNに文字列を渡す", () {
    expect(() => convertISBN("テスト"), throwsException);
  });
}
