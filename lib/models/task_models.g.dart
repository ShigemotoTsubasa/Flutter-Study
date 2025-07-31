// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModels _$TaskModelsFromJson(Map<String, dynamic> json) => TaskModels(
  categoryId: (json['categoryId'] as num).toInt(),
  taskId: json['taskId'] as String,
  taskName: json['taskName'] as String,
  taskDescription: json['taskDescription'] as String,
  startAt: DateTime.parse(json['startAt'] as String),
  endAt: DateTime.parse(json['endAt'] as String),
  isCompleted: json['isCompleted'] as bool,
);

Map<String, dynamic> _$TaskModelsToJson(TaskModels instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'taskId': instance.taskId,
      'taskName': instance.taskName,
      'taskDescription': instance.taskDescription,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'isCompleted': instance.isCompleted,
    };
