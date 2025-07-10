import 'package:flutter/material.dart';
import 'package:news_app/main.dart';
import 'package:news_app/screen/news_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _searchCategories = [
    {'name': 'ビジネス', 'value': 'business'},
    {'name': 'エンタメ', 'value': 'entertainment'},
    {'name': '健康', 'value': 'health'},
    {'name': '科学', 'value': 'science'},
    {'name': 'スポーツ', 'value': 'sports'},
    {'name': 'テクノロジー', 'value': 'technology'},
  ];

  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsApp(searchValue: _searchController.text),
                      ),
                    );
                  },
                  child: Text("検索"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _selectedCategory = null;
                    });
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => NewsApp()));
                  },
                  child: Text("クリア"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _searchCategories.length,
              itemBuilder: (context, index) {
                final category = _searchCategories[index];
                final isSelected = _selectedCategory == category['value'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['value'];
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewsApp(
                          searchValue: _searchController.text,
                          categoryValue: category['value'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.shade100
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          category['name'],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.shade700,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
