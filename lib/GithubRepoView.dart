import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:search_github_repository/github_response_json.dart';

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
  GitHubSearchResponse? searchResponse;
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

        debugPrint('Status Code: ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final gitHubResponse = GitHubSearchResponse.fromJson(data);
          setState(() {
            searchResponse = gitHubResponse;
            isLoading = false;
          });
          debugPrint('取得成功: ${gitHubResponse.totalCount} 件のリポジトリが見つかりました');
        } else {
          setState(() {
            error = 'エラー: ${response.statusCode}';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          error = 'ネットワークエラー: $e';
          isLoading = false;
        });
        debugPrint('例外エラー: $e');
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
            if (isLoading) const Center(child: CircularProgressIndicator()),

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

            if (searchResponse != null)
              Column(
                children: [
                  Text(
                    '検索結果: ${searchResponse!.totalCount}件',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResponse!.items.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final repository = searchResponse!.items[index];
                      return _buildRepositoryCard(repository);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepositoryCard(Repository repository) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
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
                    image: NetworkImage(repository.owner.avatarUrl),
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
                  Text(
                    repository.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  Divider(color: Colors.black),
                  Text(
                    repository.description ?? '説明がありません。',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.orange),
                      Text(' ${repository.stargazersCount}'),
                      SizedBox(width: 10),
                      Icon(Icons.code, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
