import 'dart:developer';

import 'package:first_app/Dialog/notification_manager.dart';
import 'package:flutter/material.dart';

class EditTodoDialog extends StatefulWidget {
  final int index;
  final String currentTodo;
  final Function(int, String) onEditTodo;
  const EditTodoDialog({
    super.key,
    required this.index,
    required this.currentTodo,
    required this.onEditTodo,
  });
  @override
  State<EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.currentTodo;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Todo"),
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
              widget.onEditTodo(widget.index, _controller.text.trim());
              log("Todoが変更されました");
              log("Todoの内容: ${_controller.text}");
              Navigator.of(context).pop();
            } else {
              NotificationManager().showError("Todoの内容を入力してください", context);
            }
          },
          child: const Text("変更"),
        ),
      ],
    );
  }
}
