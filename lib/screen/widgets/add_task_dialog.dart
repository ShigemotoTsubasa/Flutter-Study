import 'package:first_app/models/task_models.dart';
import 'package:first_app/services/notification_service.dart';
import 'package:first_app/services/task_categories_service.dart';
import 'package:first_app/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskDialog extends ConsumerStatefulWidget {
  const AddTaskDialog({super.key});

  @override
  ConsumerState<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends ConsumerState<AddTaskDialog> {
  final taskNameController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  var selectedTaskCategory = 0;

  // 日時選択のための変数を追加
  DateTime startAt = DateTime.now();
  DateTime endAt = DateTime.now().add(const Duration(days: 1));

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
            // 開始日時が終了日時より後の場合、終了日時を調整
            if (startAt.isAfter(endAt)) {
              endAt = startAt.add(const Duration(hours: 1));
            }
          } else {
            // 終了日時が開始日時より前の場合は設定しない
            if (newDateTime.isAfter(startAt)) {
              endAt = newDateTime;
            } else {
              // エラーメッセージを表示
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
      title: const Text('タスクを追加'),
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
              decoration: const InputDecoration(labelText: 'タスクの詳細'),
              controller: taskDescriptionController,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: selectedTaskCategory == 0 ? null : selectedTaskCategory,
              items: taskCategories.when(
                data: (categories) {
                  return categories.map((category) {
                    return DropdownMenuItem(
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
                  selectedTaskCategory = value ?? 0;
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
        ElevatedButton(
          onPressed: () async {
            // バリデーション
            if (taskNameController.text.isEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('タスク名を入力してください')));
              return;
            }

            if (selectedTaskCategory == 0) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('カテゴリを選択してください')));
              return;
            }

            final newTask = TaskModels(
              categoryId: selectedTaskCategory,
              taskId: DateTime.now().toIso8601String(),
              taskName: taskNameController.text,
              taskDescription: taskDescriptionController.text,
              startAt: startAt,
              endAt: endAt,
              isCompleted: false,
            );

            // タスクを追加
            ref.read(taskServiceProvider.notifier).addTask(newTask);

            // 通知をスケジュール
            await ref
                .read(notificationServiceProvider)
                .scheduleTaskNotifications(newTask);
            debugPrint("追加タスク保存ボタンが押されました。");

            if (mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('追加'),
        ),
      ],
    );
  }
}
