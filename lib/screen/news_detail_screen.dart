import 'package:flutter/material.dart';
import 'package:news_app/models/api_data_models.dart';
import 'package:news_app/models/favorite_data_models.dart';
import 'package:news_app/services/favorite_service.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsData newsData;

  const NewsDetailScreen({super.key, required this.newsData});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    setState(() {
      _isFavorite = _favoriteService.isFavorite(widget.newsData.url);
    });
  }

  void _toggleFavorite() async {
    final favoriteData = FavoriteNewsData.fromNewsData(widget.newsData);

    if (_isFavorite) {
      await _favoriteService.removeFavorite(favoriteData);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('お気に入りから削除しました')));
    } else {
      await _favoriteService.addFavorite(favoriteData);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('お気に入りに追加しました')));
    }
    _checkFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.newsData.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 画像
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.newsData.urlToImage ??
                                'https://via.placeholder.com/200',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // タイトル
                    Text(
                      widget.newsData.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: _toggleFavorite,
                        color: _isFavorite ? Colors.red : Colors.grey,
                        icon: _isFavorite
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
                      ),
                    ),
                    // 説明文
                    Text(
                      widget.newsData.content ?? '説明がありません',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
