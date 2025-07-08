import 'package:first_app/Dialog/addTodoDialog.dart';
import 'package:first_app/Dialog/editTodoDialog.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App1',
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
    if (todos.contains(todo)) {
      // 重複している場合はエラーメッセージを表示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('同じタイトルのTodoが既に存在します'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      todos.add(todo);
    });
  }

  void _editTodo(int index, String newTodo) {
    for (int i = 0; i < todos.length; i++) {
      if (i != index && todos[i] == newTodo) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('同じタイトルのTodoが既に存在します'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
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
