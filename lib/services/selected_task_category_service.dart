import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_task_category_service.g.dart';

@riverpod
class SelectedTaskCategoryService extends _$SelectedTaskCategoryService {
  @override
  int build() {
    return 0;
  }

  void selectCategory(int categoryId) {
    state = categoryId; // 選択されたカテゴリのIDを更新
  }
}
