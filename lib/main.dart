import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/screen/favorite_screen.dart';
import 'package:news_app/screen/news_screen.dart';
import 'package:news_app/screen/search_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.mise.toml');
  runApp(const NewsApp());
}

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  int _currentIndex = 0; // 現在のページインデックス

  // ページリスト
  final List<Widget> _pages = [NewsScreen(), SearchScreen(), FavoriteScreen()];

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
