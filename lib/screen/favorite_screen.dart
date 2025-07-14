import 'package:flutter/material.dart';
import 'package:news_app/models/api_data_models.dart';
import 'package:news_app/models/favorite_data_models.dart';
import 'package:news_app/screen/news_detail_screen.dart';
import 'package:news_app/services/favorite_service.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  List<FavoriteNewsData> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // サービスからの変更を監視するためにリスナーを登録
    _favoriteService.addListener(_onFavoritesChanged);
    // 初回のデータを読み込む
    _loadFavorites();
  }

  @override
  void dispose() {
    // ウィジェットが破棄される際にリスナーを解除
    _favoriteService.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  // お気に入りの状態が変更されたときに呼び出されるコールバック
  void _onFavoritesChanged() {
    // サービスから最新のデータを取得してUIを更新
    if (mounted) {
      _loadFavorites();
    }
  }

  void _loadFavorites() {
    setState(() {
      _favorites = _favoriteService.getFavorites();
      _isLoading = false;
    });
  }

  Future<void> _refreshFavorites() async {
    // ファイルから強制的に再読み込み
    await _favoriteService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favorites.isEmpty) {
      return const Center(child: Text('お気に入りがありません'));
    }

    return RefreshIndicator(
      onRefresh: _refreshFavorites,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final newsItem = _favorites[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: newsItem.urlToImage != null
                  ? Image.network(
                      newsItem.urlToImage!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.article, size: 80),
              title: Text(
                newsItem.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                newsItem.description ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                // 詳細画面に遷移するだけ。戻ってきたときの更新はリスナーが自動で行う。
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(
                      newsData: NewsData(
                        title: newsItem.title,
                        description: newsItem.description,
                        urlToImage: newsItem.urlToImage,
                        url: newsItem.url,
                        content: newsItem.content,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
