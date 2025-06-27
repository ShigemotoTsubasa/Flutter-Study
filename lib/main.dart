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

class TodoHome extends StatefulWidget {
  const TodoHome({super.key});

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  List<String> todos = [];

  void _onDeleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void _addTodo(String todo) {
    setState(() {
      todos.add(todo);
    });
  }

  void _editTodo(int index, String newTodo) {
    setState(() {
      todos[index] = newTodo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo App")),
      body: TodoList(
        todos: todos,
        onDeleteTodo: _onDeleteTodo,
        onEditTodo: _editTodo,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("ボタンが押されました");
          showDialog(
            context: context,
            builder: (BuildContext context) {
              print("ダイアログが表示されました");
              return AddTodoDialog(onAddTodo: _addTodo);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  final List<String> todos;
  final Function(int) onDeleteTodo;
  final Function(int, String) onEditTodo;

  const TodoList({
    super.key,
    required this.todos,
    required this.onDeleteTodo,
    required this.onEditTodo,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var todo in todos)
          ListTile(
            title: Text(todo),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    print("編集ボタンが押されました");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        print("編集ダイアログが表示されました");
                        return EditTodoDialog(
                          index: todos.indexOf(todo),
                          currentTodo: todo,
                          onEditTodo: onEditTodo,
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    print("削除ボタンが押されました。");
                    onDeleteTodo(todos.indexOf(todo));
                    print("Todoが削除されました: $todo");
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

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
            print("Todoが追加されました");
            print("Todoの内容: ${_controller.text}");
            if (_controller.text.isNotEmpty) {
              widget.onAddTodo(_controller.text);
            }
            Navigator.of(context).pop();
          },
          child: const Text("追加"),
        ),
      ],
    );
  }
}

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
            print("Todoが変更されました");
            print("Todoの内容: ${_controller.text}");
            if (_controller.text.isNotEmpty) {
              widget.onEditTodo(widget.index, _controller.text);
            }
            Navigator.of(context).pop();
          },
          child: const Text("変更"),
        ),
      ],
    );
  }
}
