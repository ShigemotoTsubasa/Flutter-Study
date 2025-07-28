import 'dart:developer';
import 'package:first_app/Dialog/notification_manager.dart';
import 'package:flutter/material.dart';

class AddTodoDialog extends StatefulWidget {
  final Function(String) onAddTodo;

  const AddTodoDialog({super.key, required this.onAddTodo});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Todo"),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: "タイトル入力"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("キャンセル"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onAddTodo(_controller.text.trim());
              log("Todoが追加されました");
              log("Todoの内容: ${_controller.text}");
              Navigator.of(context).pop();
            } else {
              NotificationManager.showError("Todoの内容を入力してください", context);
            }
          },
          child: const Text("追加"),
        ),
      ],
    );
  }
}
