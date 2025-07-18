import 'package:flutter/material.dart';
import 'package:search_github_repository/GithubRepoView.dart';

void main() {
  runApp(const search_github_repository_app());
}

class search_github_repository_app extends StatelessWidget {
  const search_github_repository_app({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: SearchInputPage())),
    );
  }
}

class SearchInputPage extends StatefulWidget {
  const SearchInputPage({super.key});

  @override
  _SearchInputPageState createState() => _SearchInputPageState();
}

class _SearchInputPageState extends State<SearchInputPage> {
  final TextEditingController _controller = TextEditingController();
  String? searchRepo;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'リポジトリ名',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchRepo = value.isEmpty ? null : value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (searchRepo != null && searchRepo!.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          GithubRepoView(searchRepo: searchRepo!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('リポジトリ名が空です。入力してください')),
                  );
                }
              },
              child: const Text('検索'),
            ),
          ],
        ),
      ),
    );
  }
}
