import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskDialog extends ConsumerWidget {
  const AddTaskDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('タスクを追加'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'タスク名'),
            onChanged: (value) {
              // TODO: 入力されたタスク名を状態に保存する処理を実装
            },
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: タスク追加処理を実装
                },
                child: const Text('追加'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ダイアログを閉じる
                },
                child: const Text('キャンセル'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
