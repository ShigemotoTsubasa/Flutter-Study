import 'package:json_annotation/json_annotation.dart';

part 'task_categories_models.g.dart';

@JsonSerializable(createToJson: true, createFactory: true)
class TaskCategory {
  final String categoryName;
  final int categoryId;

  TaskCategory({required this.categoryName, required this.categoryId});

  factory TaskCategory.fromJson(Map<String, dynamic> json) {
    return TaskCategory(
      categoryId: int.parse(json['categoryId'].toString()),
      categoryName: json['categoryName'] as String,
    );
  }
  Map<String, dynamic> toJson() => _$TaskCategoryToJson(this);
}
