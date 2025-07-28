import 'package:json_annotation/json_annotation.dart';

part 'task_categories_models.g.dart';

@JsonSerializable(createToJson: true, createFactory: true)
class TaskCategory {
  final String categoryName;
  final String categoryId;

  TaskCategory({required this.categoryName, required this.categoryId});

  factory TaskCategory.fromJson(Map<String, dynamic> json) =>
      _$TaskCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$TaskCategoryToJson(this);
}
