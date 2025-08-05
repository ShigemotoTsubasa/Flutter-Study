import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/favorite_data_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_service.g.dart';

@riverpod
class FavoritesNotifier extends _$FavoritesNotifier {
  static const String _fileName = 'favorites.json';

  // buildメソッドで初期状態をロード
  @override
  Future<List<FavoriteNewsData>> build() async {
    return _loadFavorites();
  }

  Future<void> addFavorite(FavoriteNewsData news) async {
    // 現在の状態を取得
    final currentState = state.value ?? [];
    if (!currentState.any((item) => item.url == news.url)) {
      final newState = [...currentState, news];
      await _saveFavorites(newState);
      state = AsyncData(newState); // 状態を更新
    }
  }

  Future<void> removeFavoriteByUrl(String url) async {
    final currentState = state.value ?? [];
    final newState = currentState.where((item) => item.url != url).toList();
    await _saveFavorites(newState);
    state = AsyncData(newState); // 状態を更新
  }

  bool isFavorite(String url) {
    return state.value?.any((item) => item.url == url) ?? false;
  }

  Future<void> _saveFavorites(List<FavoriteNewsData> favorites) async {
    try {
      final file = await _getLocalFile();
      final jsonData = favorites.map((item) => item.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      debugPrint("お気に入り保存エラー: $e");
    }
  }

  Future<List<FavoriteNewsData>> _loadFavorites() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final jsonData = jsonDecode(contents) as List<dynamic>;
        return jsonData.map((item) => FavoriteNewsData.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint("お気に入り読み込みエラー: $e");
    }
    return [];
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }
}
