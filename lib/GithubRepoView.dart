import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GithubRepoView extends StatelessWidget {
  final String searchRepo;

  const GithubRepoView({super.key, required this.searchRepo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GitHub Repository: $searchRepo')),
      body: Center(child: SearchGithubRepo(searchRepo: searchRepo)),
    );
  }
}

class SearchGithubRepo extends StatefulWidget {
  final String? searchRepo;
  const SearchGithubRepo({super.key, this.searchRepo});

  @override
  _SearchGithubRepo createState() => _SearchGithubRepo();
}

class _SearchGithubRepo extends State<SearchGithubRepo> {
  late final String? searchRepo;

  Future<void> _searchRepo() async {
    if (searchRepo != null && searchRepo!.isNotEmpty) {
      try {
        final searchRepoResult = await http.get(
          Uri.parse('https://api.github.com/repos/$searchRepo'),
          headers: {'Accept': 'application/vnd.github.v3+json'},
        );
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching for repository: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _searchRepo();
    final searchRepoResult =
        widget.searchRepo != null && widget.searchRepo!.isNotEmpty
        ? Text('Searching for repository: ${widget.searchRepo}')
        : const Text('Please enter a repository name.');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView(children: [searchRepoResult]),
          ],
        ),
      ),
    );
  }
}
