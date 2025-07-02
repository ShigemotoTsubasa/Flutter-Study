import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GithubRepoView extends StatelessWidget {
  final String searchRepo;

  const GithubRepoView({super.key, required this.searchRepo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GitHub Repository: $searchRepo')),
      body: SearchGithubRepo(searchRepo: searchRepo),
    );
  }
}

class SearchGithubRepo extends StatefulWidget {
  final String? searchRepo;
  const SearchGithubRepo({super.key, this.searchRepo});

  @override
  _SearchGithubRepoState createState() => _SearchGithubRepoState();
}

class _SearchGithubRepoState extends State<SearchGithubRepo> {
  Map<String, dynamic>? repoData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _searchRepo();
  }

  Future<void> _searchRepo() async {
    if (widget.searchRepo != null && widget.searchRepo!.isNotEmpty) {
      try {
        setState(() {
          isLoading = true;
          error = null;
        });

        final response = await http.get(
          Uri.parse(
            'https://api.github.com/search/repositories?q=${widget.searchRepo}',
          ),
          headers: {'Accept': 'application/vnd.github.v3+json'},
        );

        // ステータスコードを確認
        print('Status Code: ${response.statusCode}');
        print('Response Headers: ${response.headers}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            repoData = data;
            isLoading = false;
          });
          print('取得成功: ${data['full_name']}');
        } else {
          setState(() {
            error = 'エラー: ${response.statusCode}';
            isLoading = false;
          });
          print('エラー: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        setState(() {
          error = 'ネットワークエラー: $e';
          isLoading = false;
        });
        print('例外エラー: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ローディング状態の表示
            if (isLoading) const Center(child: CircularProgressIndicator()),

            // エラー状態の表示
            if (error != null)
              Center(
                child: Column(
                  children: [
                    Text(
                      'エラーが発生しました: $error',
                      style: TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(onPressed: _searchRepo, child: Text('再試行')),
                  ],
                ),
              ),

            // データが取得できた場合の表示
            if (repoData != null)
              for (var i = 0; i < repoData!['items'].length; i++)
                SizedBox(
                  height: 230,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 35,
                        left: 20,
                        // elevationを付けるためMaterialウィジェットを使用
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
                                  '${repoData!['items'][i]['owner']['avatar_url']}', // 画像URLを取得
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
                                '${repoData!['items'][i]['name']}', // リポジトリ名を取得
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                              Divider(color: Colors.black),
                              // 説明文
                              Text(
                                '${repoData!['items'][i]['description'] ?? '説明がありません。'}', // 説明文を取得
                                style: TextStyle(
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
          ],
        ),
      ),
    );
  }
}
