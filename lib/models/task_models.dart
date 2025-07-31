import 'package:json_annotation/json_annotation.dart';

part 'task_models.g.dart';

@JsonSerializable(createToJson: true, createFactory: true)
class TaskModels {
  final int categoryId;
  final String taskId;
  final String taskName;
  final String taskDescription;
  final DateTime startAt;
  final DateTime endAt;
  final bool isCompleted;

  TaskModels({
    required this.categoryId,
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.startAt,
    required this.endAt,
    required this.isCompleted,
  });

  factory TaskModels.fromJson(Map<String, dynamic> json) =>
      _$TaskModelsFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelsToJson(this);
}
