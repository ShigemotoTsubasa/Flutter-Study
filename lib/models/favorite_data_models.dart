import 'package:json_annotation/json_annotation.dart';

part 'favorite_data_models.g.dart';

@JsonSerializable()
class FavoriteNewsData {
  final String title;
  final String? author;
  final String url;
  final String? description;
  final String? urlToImage;
  final String? content;

  FavoriteNewsData({
    required this.title,
    this.author,
    required this.url,
    this.description,
    this.urlToImage,
    this.content,
  });

  factory FavoriteNewsData.fromJson(Map<String, dynamic> json) =>
      _$FavoriteNewsDataFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteNewsDataToJson(this);
  factory FavoriteNewsData.fromNewsData(dynamic newsData) {
    return FavoriteNewsData(
      title: newsData.title,
      author: newsData.author,
      url: newsData.url,
      description: newsData.description,
      urlToImage: newsData.urlToImage,
    );
  }
}
