import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:news_app/models/favorite_data_models.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteService {
  static const String _fileName = 'favorites.json';
  List<FavoriteNewsData> _favorites = [];

  // シングルトンパターン
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  // 初期化（アプリ起動時に呼び出す）
  Future<void> initialize() async {
    await _loadFavorites();
  }

  // お気に入りを追加
  Future<void> addFavorite(FavoriteNewsData news) async {
    // 重複チェック
    if (!_favorites.any((item) => item.url == news.url)) {
      _favorites.add(news);
      await _saveFavorites();
      debugPrint("お気に入りに追加: ${news.title}");
    } else {
      debugPrint("既にお気に入りに存在: ${news.title}");
    }
  }

  // お気に入りを削除
  Future<void> removeFavorite(FavoriteNewsData news) async {
    _favorites.removeWhere((item) => item.url == news.url);
    await _saveFavorites();
    debugPrint("お気に入りから削除: ${news.title}");
  }

  // URLでお気に入りを削除
  Future<void> removeFavoriteByUrl(String url) async {
    _favorites.removeWhere((item) => item.url == url);
    await _saveFavorites();
    debugPrint("お気に入りから削除: $url");
  }

  // お気に入りリストを取得
  List<FavoriteNewsData> getFavorites() {
    return List.from(_favorites);
  }

  // 指定されたURLがお気に入りかどうかチェック
  bool isFavorite(String url) {
    return _favorites.any((item) => item.url == url);
  }

  // お気に入りの数を取得
  int getFavoriteCount() {
    return _favorites.length;
  }

  // JSONファイルからお気に入りを読み込み
  Future<void> _loadFavorites() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final jsonData = jsonDecode(contents) as List<dynamic>;
        _favorites = jsonData
            .map((item) => FavoriteNewsData.fromJson(item))
            .toList();
        debugPrint("お気に入り読み込み完了: ${_favorites.length}件");
      } else {
        debugPrint("お気に入りファイルが存在しません");
      }
    } catch (e) {
      debugPrint("お気に入り読み込みエラー: $e");
      _favorites = [];
    }
  }

  // JSONファイルにお気に入りを保存
  Future<void> _saveFavorites() async {
    try {
      final file = await _getLocalFile();
      final jsonData = _favorites.map((item) => item.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
      debugPrint("お気に入り保存完了: ${_favorites.length}件");
    } catch (e) {
      debugPrint("お気に入り保存エラー: $e");
    }
  }

  // ローカルファイルを取得
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  // お気に入りをすべて削除
  Future<void> clearAllFavorites() async {
    _favorites.clear();
    await _saveFavorites();
    debugPrint("すべてのお気に入りを削除");
  }

  // デバッグ用：お気に入りリストを表示
  void debugPrintFavorites() {
    debugPrint("=== お気に入りリスト ===");
    for (int i = 0; i < _favorites.length; i++) {
      debugPrint("${i + 1}. ${_favorites[i].title}");
    }
    debugPrint("=====================");
  }
}
