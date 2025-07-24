import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/api_data_models.dart';
import 'package:news_app/models/favorite_data_models.dart';
import 'package:news_app/services/favorite_service.dart';

class NewsDetailScreen extends ConsumerWidget {
  final NewsData newsData;
  const NewsDetailScreen({super.key, required this.newsData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesNotifier = ref.watch(favoritesNotifierProvider.notifier);
    final isFavorite = ref.watch(
      favoritesNotifierProvider.select(
        (favorites) =>
            favorites.value?.any((fav) => fav.url == newsData.url) ?? false,
      ),
    );
    final notifier = ref.read(favoritesNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(newsData.title)),
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
                            newsData.urlToImage ??
                                'https://via.placeholder.com/200',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // タイトル
                    Text(
                      newsData.title,
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
                        onPressed: isFavorite
                            ? () => notifier.removeFavoriteByUrl(newsData.url)
                            : () => notifier.addFavorite(
                                FavoriteNewsData.fromNewsData(newsData),
                              ),
                        color: isFavorite ? Colors.red : Colors.grey,
                        icon: isFavorite
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
                      ),
                    ),
                    // 説明文
                    Text(
                      newsData.content ?? '説明がありません',
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
