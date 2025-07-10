import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/models/api_data_models.dart';
import 'package:news_app/screen/news_detail_screen.dart';
import 'package:news_app/services/news_api_service.dart';

class NewsScreen extends StatefulWidget {
  final String? searchValue;
  final String? categoryValue;
  const NewsScreen({super.key, this.searchValue, this.categoryValue});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsApiService _newsApiService = NewsApiService();
  List<NewsData> _newsList = [];
  bool _isLoading = true;
  String? _error;
  String? searchValue;
  String? categoryValue;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final newsList = await _newsApiService.fetchNews(
        searchValue: widget.searchValue ?? '',
        categoryValue: widget.categoryValue ?? '',
      );

      setState(() {
        _newsList = newsList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    await _loadNews();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'エラーが発生しました\n$_error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadNews, child: const Text('再試行')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _newsList.length,
        itemBuilder: (context, index) {
          final newsItem = _newsList[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(newsData: newsItem),
                ),
              );
              print('ニュースアイテムがタップされました: ${newsItem.title}');
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
    );
  }
}
