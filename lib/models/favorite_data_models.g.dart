// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_data_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteNewsData _$FavoriteNewsDataFromJson(Map<String, dynamic> json) =>
    FavoriteNewsData(
      title: json['title'] as String,
      author: json['author'] as String?,
      url: json['url'] as String,
      description: json['description'] as String?,
      urlToImage: json['urlToImage'] as String?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$FavoriteNewsDataToJson(FavoriteNewsData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'author': instance.author,
      'url': instance.url,
      'description': instance.description,
      'urlToImage': instance.urlToImage,
      'content': instance.content,
    };
