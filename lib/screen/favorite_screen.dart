import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/api_data_models.dart';
import 'package:news_app/models/favorite_data_models.dart';
import 'package:news_app/screen/news_detail_screen.dart';
import 'package:news_app/services/favorite_service.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesNotifierProvider);

    return favoritesAsync.when(
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stackTrace) {
        return const Center(child: Text('お気に入りの読み込みに失敗しました'));
      },
      data: (favorites) {
        if (favorites.isEmpty) {
          return const Center(child: Text('お気に入りはありません'));
        }
        return RefreshIndicator(
          onRefresh: () => ref.refresh(favoritesNotifierProvider.future),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final newsItem = favorites[index];
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
      },
    );
  }
}
