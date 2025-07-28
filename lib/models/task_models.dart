import 'package:json_annotation/json_annotation.dart';

part 'task_models.g.dart';

@JsonSerializable(createToJson: true, createFactory: true)
class TaskModels {
  final String categoryId;
  final String taskId;
  final String taskName;
  final String taskDescription;

  TaskModels({
    required this.categoryId,
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
  });

  factory TaskModels.fromJson(Map<String, dynamic> json) =>
      _$TaskModelsFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelsToJson(this);
}
