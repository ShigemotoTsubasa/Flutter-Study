import 'package:first_app/models/task_models.dart';
import 'package:first_app/services/notification_service.dart';
import 'package:first_app/services/task_categories_service.dart';
import 'package:first_app/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditTaskDialog extends ConsumerStatefulWidget {
  const EditTaskDialog({super.key, required this.task});

  final TaskModels task;

  @override
  ConsumerState<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends ConsumerState<EditTaskDialog> {
  late DateTime startAt;
  late DateTime endAt;
  late final TextEditingController taskNameController;
  late final TextEditingController taskDescriptionController;
  late int selectedTaskCategory;

  @override
  void initState() {
    super.initState();

    // 編集対象のタスクの値で各フィールドを初期化
    taskNameController = TextEditingController(text: widget.task.taskName);
    taskDescriptionController = TextEditingController(
      text: widget.task.taskDescription,
    );
    startAt = widget.task.startAt;
    endAt = widget.task.endAt;
    selectedTaskCategory = widget.task.categoryId;
  }

  @override
  void dispose() {
    taskNameController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  // 日付選択メソッド
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startAt : endAt,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      // 時刻選択
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStartDate ? startAt : endAt),
      );

      if (pickedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          if (isStartDate) {
            startAt = newDateTime;
            if (startAt.isAfter(endAt)) {
              endAt = startAt.add(const Duration(hours: 1));
            }
          } else {
            if (newDateTime.isAfter(startAt)) {
              endAt = newDateTime;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('終了日時は開始日時より後に設定してください')),
              );
            }
          }
        });
      }
    }
  }

  // 日時をフォーマットして表示するメソッド
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final taskCategories = ref.watch(taskCategoriesServiceProvider);

    return AlertDialog(
      title: const Text('タスク編集'),
      content: SingleChildScrollView(
        // スクロール可能にする
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'タスク名'),
              controller: taskNameController,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'タスク詳細'),
              controller: taskDescriptionController,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedTaskCategory,
              items: taskCategories.when(
                data: (categories) {
                  return categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.categoryId,
                      child: Text(category.categoryName),
                    );
                  }).toList();
                },
                loading: () => const [
                  DropdownMenuItem(child: CircularProgressIndicator()),
                ],
                error: (error, stack) => [
                  DropdownMenuItem(child: Text('Error: $error')),
                ],
              ),
              onChanged: (value) {
                setState(() {
                  selectedTaskCategory = value ?? selectedTaskCategory;
                });
              },
              decoration: const InputDecoration(labelText: 'カテゴリを選択'),
            ),
            const SizedBox(height: 16),

            // 開始日時選択
            ListTile(
              title: const Text('開始日時'),
              subtitle: Text(_formatDateTime(startAt)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),

            // 終了日時選択
            ListTile(
              title: const Text('終了日時'),
              subtitle: Text(_formatDateTime(endAt)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () async {
            // 既存の通知をキャンセル
            final notificationService = ref.read(notificationServiceProvider);
            await notificationService.cancelTaskNotifications(
              widget.task.taskId,
            );

            // タスクを更新
            ref
                .read(taskServiceProvider.notifier)
                .editTask(
                  taskId: widget.task.taskId,
                  taskName: taskNameController.text,
                  taskDescription: taskDescriptionController.text,
                  startAt: startAt, // 選択された日時を使用
                  endAt: endAt, // 選択された日時を使用
                  categoryId: selectedTaskCategory,
                );

            // 更新されたタスクで通知をスケジュール
            final updatedTask = TaskModels(
              categoryId: selectedTaskCategory,
              taskId: widget.task.taskId,
              taskName: taskNameController.text,
              taskDescription: taskDescriptionController.text,
              startAt: startAt,
              endAt: endAt,
              isCompleted: widget.task.isCompleted,
            );
            await notificationService.scheduleTaskNotifications(updatedTask);

            if (mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
