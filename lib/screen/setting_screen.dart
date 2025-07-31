import 'package:first_app/models/task_categories_models.dart';
import 'package:first_app/services/notification_service.dart';
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
                                debugPrint("カテゴリ削除ボタンがクリックされました。");
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

          // 通知テスト機能を追加
          ExpansionTile(
            title: const Text('通知設定'),
            children: [
              ListTile(
                title: const Text('テスト通知を送信'),
                subtitle: const Text('通知が正常に動作するかテストします'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final notificationService = ref.read(
                      notificationServiceProvider,
                    );
                    await notificationService.showNotification(
                      id: 999,
                      title: 'テスト通知',
                      body: '通知が正常に動作しています！',
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('テスト通知を送信しました')),
                      );
                    }
                  },
                  child: const Text('送信'),
                ),
              ),
              ListTile(
                title: const Text('保留中の通知を確認'),
                subtitle: const Text('スケジュールされた通知の数を確認します'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final notificationService = ref.read(
                      notificationServiceProvider,
                    );
                    final pending = await notificationService
                        .getPendingNotifications();

                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('保留中の通知'),
                          content: Text('${pending.length}件の通知がスケジュールされています'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('確認'),
                ),
              ),
            ],
          ),
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
                    categoryId: DateTime.now().millisecondsSinceEpoch,
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
