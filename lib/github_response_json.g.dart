// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_response_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GitHubSearchResponse _$GitHubSearchResponseFromJson(
  Map<String, dynamic> json,
) => GitHubSearchResponse(
  totalCount: (json['total_count'] as num).toInt(),
  incompleteResults: json['incomplete_results'] as bool,
  items: (json['items'] as List<dynamic>)
      .map((e) => Repository.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GitHubSearchResponseToJson(
  GitHubSearchResponse instance,
) => <String, dynamic>{
  'total_count': instance.totalCount,
  'incomplete_results': instance.incompleteResults,
  'items': instance.items,
};

Repository _$RepositoryFromJson(Map<String, dynamic> json) => Repository(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  fullName: json['full_name'] as String,
  description: json['description'] as String?,
  owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
  stargazersCount: (json['stargazers_count'] as num).toInt(),
  watchersCount: (json['watchers_count'] as num).toInt(),
  forksCount: (json['forks_count'] as num).toInt(),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$RepositoryToJson(Repository instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'full_name': instance.fullName,
      'description': instance.description,
      'owner': instance.owner,
      'stargazers_count': instance.stargazersCount,
      'watchers_count': instance.watchersCount,
      'forks_count': instance.forksCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
  login: json['login'] as String,
  id: (json['id'] as num).toInt(),
  avatarUrl: json['avatar_url'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
  'login': instance.login,
  'id': instance.id,
  'avatar_url': instance.avatarUrl,
  'type': instance.type,
};
