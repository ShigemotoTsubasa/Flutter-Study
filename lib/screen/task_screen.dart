import 'package:first_app/screen/widgets/add_task_dialog.dart';
import 'package:first_app/screen/widgets/task_tabs.dart';
import 'package:first_app/services/task_categories_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          // SingleChildScrollViewとExpandedを削除し、TaskTabsを直接配置
          const TaskTabs(),
          // TODO: ここに選択されたカテゴリのタスク一覧を表示する
          const Expanded(child: Center(child: Text('タスク一覧'))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('タスク追加ボタンが押されました');
          showDialog(
            context: context,
            builder: (context) => const AddTaskDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
