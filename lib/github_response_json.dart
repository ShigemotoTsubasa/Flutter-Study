import 'package:json_annotation/json_annotation.dart';

part 'github_response_json.g.dart';

@JsonSerializable()
class GitHubSearchResponse {
  @JsonKey(name: 'total_count')
  final int totalCount;

  @JsonKey(name: 'incomplete_results')
  final bool incompleteResults;

  final List<Repository> items;

  GitHubSearchResponse({
    required this.totalCount,
    required this.incompleteResults,
    required this.items,
  });

  factory GitHubSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$GitHubSearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GitHubSearchResponseToJson(this);
}

@JsonSerializable()
class Repository {
  final int id;
  final String name;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String? description;
  final Owner owner;
  @JsonKey(name: 'stargazers_count')
  final int stargazersCount;
  @JsonKey(name: 'watchers_count')
  final int watchersCount;
  @JsonKey(name: 'forks_count')
  final int forksCount;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Repository({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    required this.owner,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Repository.fromJson(Map<String, dynamic> json) =>
      _$RepositoryFromJson(json);

  Map<String, dynamic> toJson() => _$RepositoryToJson(this);
}

@JsonSerializable()
class Owner {
  final String login;
  final int id;
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  final String type;

  Owner({
    required this.login,
    required this.id,
    required this.avatarUrl,
    required this.type,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}
