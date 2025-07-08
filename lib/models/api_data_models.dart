import 'package:json_annotation/json_annotation.dart';

part 'api_data_models.g.dart';

@JsonSerializable()
class NewsData {
  final String title;
  final String? author;
  final String url;
  final String? description;
  final String? urlToImage;
  final String? content;

  NewsData({
    required this.title,
    this.author, // requiredを削除
    required this.url,
    this.description,
    this.urlToImage,
    this.content,
  });

  factory NewsData.fromJson(Map<String, dynamic> json) =>
      _$NewsDataFromJson(json);

  Map<String, dynamic> toJson() => _$NewsDataToJson(this);
}
