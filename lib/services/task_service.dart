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

  List<TaskModels> getTasks(int selectedCategory, bool isCompleted) {
    final tasks = state.value ?? [];
    if (selectedCategory == 0) {
      return tasks.where((task) => task.isCompleted == isCompleted).toList();
    }
    debugPrint("選択されたカテゴリ: $selectedCategory");
    debugPrint("タスク: ${tasks.map((task) => task.toJson()).toList()}");
    return tasks
        .where(
          (task) =>
              task.categoryId == selectedCategory &&
              task.isCompleted == isCompleted,
        )
        .toList();
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

  Future<void> editTask({
    required String taskId,
    required String taskName,
    required String taskDescription,
    required DateTime endAt,
    required DateTime startAt,
    required int categoryId,
  }) async {
    final currentTasks = state.value ?? [];
    final taskIndex = currentTasks.indexWhere((task) => task.taskId == taskId);

    if (taskIndex == -1) {
      debugPrint("タスクが見つかりません: $taskId");
      return;
    }

    final updatedTask = TaskModels(
      taskId: taskId,
      taskName: taskName,
      taskDescription: taskDescription,
      startAt: startAt,
      endAt: endAt,
      categoryId: categoryId,
      isCompleted: false,
    );

    final newTasks = List<TaskModels>.from(currentTasks);
    newTasks[taskIndex] = updatedTask;

    state = AsyncValue.data(newTasks);
    try {
      await _saveTasks(newTasks);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    debugPrint("タスクが更新されました: ${updatedTask.toJson()}");
  }

  Future<void> deleteTask(String taskId) async {
    final currentTasks = state.value ?? [];
    final newTasks = currentTasks
        .where((task) => task.taskId != taskId)
        .toList();

    state = AsyncValue.data(newTasks);
    try {
      await _saveTasks(newTasks);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> toggleTaskCompletion(String taskId, bool isComplated) async {
    final currentTasks = state.value ?? [];
    final taskIndex = currentTasks.indexWhere((task) => task.taskId == taskId);

    if (taskIndex == -1) {
      debugPrint("タスクが見つかりません: $taskId");
      return;
    }

    final updatedTask = TaskModels(
      taskId: currentTasks[taskIndex].taskId,
      taskName: currentTasks[taskIndex].taskName,
      taskDescription: currentTasks[taskIndex].taskDescription,
      startAt: currentTasks[taskIndex].startAt,
      endAt: currentTasks[taskIndex].endAt,
      categoryId: currentTasks[taskIndex].categoryId,
      isCompleted: isComplated,
    );

    final newTasks = List<TaskModels>.from(currentTasks);
    newTasks[taskIndex] = updatedTask;

    state = AsyncValue.data(newTasks);
    try {
      await _saveTasks(newTasks);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    debugPrint("タスクの完了状態を更新しました: ${updatedTask.toJson()}");
  }

  Future<void> _saveTasks(List<TaskModels> tasks) async {
    try {
      final file = await _getLocalFile(_fileName);
      final jsonData = tasks.map((task) => task.toJson()).toList();
      debugPrint("タスク保存: $jsonData");
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
