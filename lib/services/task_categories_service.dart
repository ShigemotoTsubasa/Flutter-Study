import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:first_app/models/task_categories_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'task_categories_service.g.dart';

@riverpod
class TaskCategoriesService extends _$TaskCategoriesService {
  static const String _fileName = 'task_categories.json';
  @override
  Future<List<TaskCategory>> build() async {
    return _loadTaskCategories();
  }

  Future<List<TaskCategory>> _loadTaskCategories() async {
    try {
      final file = await _getLocalFile(_fileName);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final jsonData = jsonDecode(contents) as List<dynamic>;
        return jsonData.map((item) => TaskCategory.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint("お気に入り読み込みエラー: $e");
    }
    return [];
  }

  Future<void> addTaskCategory(TaskCategory taskCategory) async {
    final currentCategories = state.value ?? [];
    final newCategories = [...currentCategories, taskCategory];

    state = AsyncValue.data(newCategories);
    try {
      await _saveTaskCategories(newCategories);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> _saveTaskCategories(List<TaskCategory> categories) async {
    try {
      final file = await _getLocalFile(_fileName);
      final jsonData = categories.map((cat) => cat.toJson()).toList();
      debugPrint("カテゴリ保存: ${jsonEncode(jsonData)}");
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      debugPrint("お気に入り保存エラー: $e");
    }
  }

  Future<void> deleteTaskCategory(int categoryId) async {
    final categories = await _loadTaskCategories();
    categories.removeWhere((cat) => cat.categoryId == categoryId);
    state = AsyncValue.data(categories);
    try {
      await _saveTaskCategories(categories);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<File> _getLocalFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }
}
