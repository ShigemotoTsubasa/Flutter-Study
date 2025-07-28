import 'package:first_app/models/task_categories_models.dart';
import 'package:first_app/services/task_categories_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ListTileをExpansionTileに置き換える
          ExpansionTile(
            title: const Text('カテゴリの設定'),
            // 展開時に表示するウィジェット
            children: [
              // カテゴリ一覧を表示
              ref
                  .watch(taskCategoriesServiceProvider)
                  .when(
                    data: (categories) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return ListTile(
                            title: Text(category.categoryName),
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                ref
                                    .read(
                                      taskCategoriesServiceProvider.notifier,
                                    )
                                    .deleteTaskCategory(category.categoryId);
                              },
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('Error: $error')),
                  ),
              // カテゴリ追加ボタン
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _showAddCategoryDialog(context, ref),
                  child: const Text('カテゴリを追加'),
                ),
              ),
            ],
          ),
          ListTile(
            title: const Text('設定項目2'),
            onTap: () {
              // 設定項目2の処理
            },
          ),
          // 他の設定項目を追加
        ],
      ),
    );
  }

  // カテゴリ追加ダイアログを表示するメソッド (クラス内に移動)
  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('新しいカテゴリを追加'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'カテゴリ名'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                final value = textController.text;
                if (value.isNotEmpty) {
                  final newCategory = TaskCategory(
                    categoryName: value,
                    categoryId: DateTime.now().millisecondsSinceEpoch
                        .toString(),
                  );
                  ref
                      .read(taskCategoriesServiceProvider.notifier)
                      .addTaskCategory(newCategory);
                }
                Navigator.of(context).pop();
              },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );
  }
}
