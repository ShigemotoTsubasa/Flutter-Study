import 'package:first_app/GithubRepoView.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: SearchGithubRepo())),
    );
  }
}

class SearchGithubRepo extends StatefulWidget {
  const SearchGithubRepo({super.key});

  @override
  _SearchGithubRepoState createState() => _SearchGithubRepoState();
}

class _SearchGithubRepoState extends State<SearchGithubRepo> {
  final TextEditingController _controller = TextEditingController();
  String? searchRepo;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
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
      ),
    );
  }
}
