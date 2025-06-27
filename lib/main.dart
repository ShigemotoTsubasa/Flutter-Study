import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoHome(),
    );
  }
}

class TodoHome extends StatelessWidget {
  const TodoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo App")),
      body: const TodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("ボタンが押されました");
          showDialog(
            context: context,
            builder: (BuildContext context) {
              print("ダイアログが表示されました");
              return const AddTodoDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

List<String> todos = [];

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [for (var todo in todos) ListTile(title: Text(todo))],
    );
  }
}

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

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
      title: Text("Add Todo"),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: "タイトル入力"),
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
            print("Todoが追加されました");
            print("Todoの内容: ${_controller.text}");
            if (_controller.text.isNotEmpty) {
              todos.add(_controller.text);
            }
            Navigator.of(context).pop();
          },
          child: const Text("追加"),
        ),
      ],
    );
  }
}
