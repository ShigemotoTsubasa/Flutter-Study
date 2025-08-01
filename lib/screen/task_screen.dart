import 'package:first_app/screen/widgets/add_task_dialog.dart';
import 'package:first_app/screen/widgets/edit_task_dialog.dart';
import 'package:first_app/screen/widgets/task_tabs.dart';
import 'package:first_app/services/notification_service.dart';
import 'package:first_app/services/selected_task_category_service.dart';
import 'package:first_app/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTaskCategory = ref.watch(selectedTaskCategoryServiceProvider);
    final taskService = ref.watch(taskServiceProvider);

    return taskService.when(
      data: (tasks) {
        final filteredTasks = selectedTaskCategory == 0
            ? tasks.where((task) => !task.isCompleted).toList()
            : tasks
                  .where((task) => task.categoryId == selectedTaskCategory)
                  .where((task) => !task.isCompleted)
                  .toList();

        return Scaffold(
          body: Column(
            children: [
              const TaskTabs(),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return Card(
                      child: ListTile(
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            ref
                                .read(taskServiceProvider.notifier)
                                .toggleTaskCompletion(
                                  task.taskId,
                                  value ?? false,
                                );
                          },
                        ),
                        title: Text(task.taskName),
                        subtitle: Text(task.taskDescription),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      EditTaskDialog(task: task),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                // 通知をキャンセル
                                final notificationService = ref.read(
                                  notificationServiceProvider,
                                );
                                await notificationService
                                    .cancelTaskNotifications(task.taskId);

                                // タスクを削除
                                ref
                                    .read(taskServiceProvider.notifier)
                                    .deleteTask(task.taskId);
                                debugPrint("タスク削除ボタンがクリックされました。");
                              },
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('エラー: $error')),
    );
  }
}
