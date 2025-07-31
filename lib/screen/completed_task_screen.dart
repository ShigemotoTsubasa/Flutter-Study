import 'package:first_app/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompletedTaskScreen extends ConsumerWidget {
  const CompletedTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedTasks = ref
        .watch(taskServiceProvider.notifier)
        .getTasks(0, true);

    return Scaffold(
      appBar: AppBar(title: const Text("完了タスク")),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return Card(
            child: ListTile(
              title: Text(task.taskName),
              subtitle: Text(task.taskDescription),
            ),
          );
        },
      ),
    );
  }
}
