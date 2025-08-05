import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/screen/favorite_screen.dart';
import 'package:news_app/screen/news_screen.dart';
import 'package:news_app/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:news_app/services/favorite_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.mise.toml');
  runApp(const ProviderScope(child: NewsApp()));
}

class NewsApp extends StatefulWidget {
  final String? searchValue;
  final String? categoryValue;
  const NewsApp({super.key, this.searchValue, this.categoryValue});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  String? searchValue;
  String? categoryValue;
  int _currentIndex = 0;

  // ページリスト
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    searchValue = widget.searchValue;
    categoryValue = widget.categoryValue;
    _pages = [
      NewsScreen(searchValue: searchValue, categoryValue: categoryValue),
      SearchScreen(),
      FavoriteScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("ニュースアプリ")),
        body: Center(child: _pages[_currentIndex]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // インデックスを更新
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '検索'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'お気に入り'),
          ],
        ),
      ),
    );
  }
}
