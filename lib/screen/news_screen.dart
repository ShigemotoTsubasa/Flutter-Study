import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/api_data_models.dart';
import 'package:news_app/screen/news_detail_screen.dart';
import 'package:news_app/services/news_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'news_screen.g.dart';

@riverpod
NewsApiService newsApiService(NewsApiServiceRef ref) {
  return NewsApiService();
}

@riverpod
Future<List<NewsData>> news(
  NewsRef ref, {
  String? searchValue,
  String? categoryValue,
}) async {
  final newsApiService = ref.watch(newsApiServiceProvider);
  // APIを叩いてニュースリストを返す
  final newsList = await newsApiService.fetchNews(
    searchValue: searchValue ?? '',
    categoryValue: categoryValue ?? '',
  );
  return newsList;
}

class NewsScreen extends ConsumerWidget {
  final String? searchValue;
  final String? categoryValue;
  const NewsScreen({super.key, this.searchValue, this.categoryValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNews = ref.watch(
      newsProvider(searchValue: searchValue, categoryValue: categoryValue),
    );

    // AsyncValueの状態に応じてUIを分岐
    return asyncNews.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'エラーが発生しました\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(
                  newsProvider(
                    searchValue: searchValue,
                    categoryValue: categoryValue,
                  ),
                );
              },
              child: const Text('再試行'),
            ),
          ],
        ),
      ),
      data: (newsList) => RefreshIndicator(
        onRefresh: () async {
          ref.refresh(
            newsProvider(
              searchValue: searchValue,
              categoryValue: categoryValue,
            ),
          );
          debugPrint('ニュースリストを更新しました');
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: newsList.length,
          itemBuilder: (context, index) {
            final newsItem = newsList[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(newsData: newsItem),
                  ),
                );
                debugPrint('ニュースアイテムがタップされました: ${newsItem.title}');
              },
              child: SizedBox(
                height: 230,
                child: Stack(
                  children: [
                    Positioned(
                      top: 35,
                      left: 20,
                      child: Material(
                        elevation: 4,
                        child: Container(
                          height: 180,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                        ),
                      ),
                    ),
                    // 画像部分
                    Positioned(
                      top: 0,
                      left: 30,
                      child: Card(
                        elevation: 4,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          height: 200,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                newsItem.urlToImage ??
                                    'https://via.placeholder.com/150', // 画像がない場合のプレースホルダー
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 45,
                      left: 200,
                      child: SizedBox(
                        height: 150,
                        width: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // タイトル
                            Text(
                              newsItem.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ),
                            const Divider(color: Colors.black),
                            // 説明文
                            Text(
                              newsItem.description ?? '説明がありません',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
