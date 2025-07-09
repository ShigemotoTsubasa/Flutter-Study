import 'package:flutter/material.dart';
import 'package:news_app/models/api_data_models.dart';
import 'package:news_app/models/favorite_data_models.dart';
import 'package:news_app/services/favorite_service.dart';
import 'package:news_app/screen/news_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<FavoriteNewsData> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final favorites = await FavoriteService().getFavorites();
    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favorites.isEmpty) {
      return const Center(child: Text('お気に入りがありません'));
    }

    return ListView.builder(
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
    );
  }
}
