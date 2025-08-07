import 'package:first_app/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskDetailDialog extends ConsumerWidget {
  final String taskId;
  const TaskDetailDialog({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTask = ref
        .read(taskServiceProvider.notifier)
        .getTasksByTaskId(taskId);
    return FutureBuilder(
      future: asyncTask,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: const Text('エラー'),
            content: Text('タスクの詳細を取得できませんでした: ${snapshot.error}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('閉じる'),
              ),
            ],
          );
        } else if (snapshot.hasData) {
          final task = snapshot.data!;
          return AlertDialog(
            title: const Text('タスク詳細'),
            content: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('タスク名: ${task.taskName}'),
                  Text('説明: ${task.taskDescription}'),
                  Text('開始日時: ${task.startAt}'),
                  Text('終了日時: ${task.endAt}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('閉じる'),
              ),
            ],
          );
        } else {
          return const AlertDialog(
            title: Text('タスクが見つかりません'),
            content: Text('指定されたタスクIDに該当するタスクが存在しません。'),
          );
        }
      },
    );
  }
}
