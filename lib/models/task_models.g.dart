// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModels _$TaskModelsFromJson(Map<String, dynamic> json) => TaskModels(
  categoryId: json['categoryId'] as String,
  taskId: json['taskId'] as String,
  taskName: json['taskName'] as String,
  taskDescription: json['taskDescription'] as String,
);

Map<String, dynamic> _$TaskModelsToJson(TaskModels instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'taskId': instance.taskId,
      'taskName': instance.taskName,
      'taskDescription': instance.taskDescription,
    };
