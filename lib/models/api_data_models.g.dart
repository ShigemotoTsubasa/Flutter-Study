// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_data_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsData _$NewsDataFromJson(Map<String, dynamic> json) => NewsData(
  title: json['title'] as String,
  author: json['author'] as String?,
  url: json['url'] as String,
  description: json['description'] as String?,
  urlToImage: json['urlToImage'] as String?,
  content: json['content'] as String?,
);

Map<String, dynamic> _$NewsDataToJson(NewsData instance) => <String, dynamic>{
  'title': instance.title,
  'author': instance.author,
  'url': instance.url,
  'description': instance.description,
  'urlToImage': instance.urlToImage,
  'content': instance.content,
};
