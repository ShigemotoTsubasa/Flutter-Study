import 'package:first_app/models/task_models.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:first_app/models/task_categories_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_service.g.dart';

@riverpod
class TaskService extends _$TaskService {
  final String _fileName = 'tasks.json';
  @override
  Future<List<TaskModels>> build() async {
    return _loadTask();
  }

  Future<List<TaskModels>> _loadTask() async {
    try {
      final file = await _getLocalFile(_fileName);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final jsonData = jsonDecode(contents) as List<dynamic>;
        return jsonData.map((item) => TaskModels.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint("タスク読み込みエラー: $e");
    }
    return [];
  }

  Future<void> addTask(TaskModels task) async {
    final currentTasks = state.value ?? [];

    final newTasks = [...currentTasks, task];

    state = AsyncValue.data(newTasks);

    try {
      await _saveTasks(newTasks);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> _saveTasks(List<TaskModels> tasks) async {
    try {
      final file = await _getLocalFile(_fileName);
      final jsonData = tasks.map((task) => task.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      debugPrint("タスク保存エラー: $e");
    }
  }

  Future<File> _getLocalFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }
}
