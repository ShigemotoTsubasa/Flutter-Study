import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:news_app/models/api_data_models.dart';
import 'dart:convert';

class NewsApiService {
  final String apiKey = dotenv.get('NEWS_API_KEY');
  final String apiUrl = dotenv.get('NEWS_API_URL');
  String searchValue = '';
  String categoryValue = '';

  // 初期化チェックを実行
  NewsApiService() {
    _checkApiKeyAndLoadNews();
  }

  void _checkApiKeyAndLoadNews() {
    if (apiKey.isEmpty) {
      throw Exception("APIとの接続に失敗しました。");
    } else {
      debugPrint('APIキー: $apiKey');
      // ここでニュースを取得する処理を追加
    }
  }

  Future<List<NewsData>> fetchNews({
    required String searchValue,
    required String categoryValue,
  }) async {
    Uri uri;
    // getメソッドでデータを取得する
    if (categoryValue.isEmpty && searchValue.isEmpty) {
      uri = Uri.parse('$apiUrl/everything?q=日本&apiKey=$apiKey');
    } else if (categoryValue.isEmpty) {
      uri = Uri.parse('$apiUrl/everything?q=${searchValue}&apiKey=$apiKey');
    } else {
      uri = Uri.parse(
        '$apiUrl/top-headlines?category=${categoryValue}&apiKey=$apiKey',
      );
    }
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // JSONのデータを元のデータに戻す
        final jsonData = jsonDecode(response.body);
        // mapメソッドで、Map型のデータをListに変換する
        final List<dynamic> articlesJson = jsonData['articles'];
        return articlesJson
            .map((articleJson) => NewsData.fromJson(articleJson))
            .toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }
}
