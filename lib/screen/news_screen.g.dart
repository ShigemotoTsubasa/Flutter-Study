// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newsApiServiceHash() => r'879f30afd97741129b1311e8341e9aff170b1517';

/// See also [newsApiService].
@ProviderFor(newsApiService)
final newsApiServiceProvider = AutoDisposeProvider<NewsApiService>.internal(
  newsApiService,
  name: r'newsApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$newsApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NewsApiServiceRef = AutoDisposeProviderRef<NewsApiService>;
String _$newsHash() => r'73cf2e08878ef132d796068a3a8f3224b6c5a751';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [news].
@ProviderFor(news)
const newsProvider = NewsFamily();

/// See also [news].
class NewsFamily extends Family<AsyncValue<List<NewsData>>> {
  /// See also [news].
  const NewsFamily();

  /// See also [news].
  NewsProvider call({String? searchValue, String? categoryValue}) {
    return NewsProvider(searchValue: searchValue, categoryValue: categoryValue);
  }

  @override
  NewsProvider getProviderOverride(covariant NewsProvider provider) {
    return call(
      searchValue: provider.searchValue,
      categoryValue: provider.categoryValue,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'newsProvider';
}

/// See also [news].
class NewsProvider extends AutoDisposeFutureProvider<List<NewsData>> {
  /// See also [news].
  NewsProvider({String? searchValue, String? categoryValue})
    : this._internal(
        (ref) => news(
          ref as NewsRef,
          searchValue: searchValue,
          categoryValue: categoryValue,
        ),
        from: newsProvider,
        name: r'newsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$newsHash,
        dependencies: NewsFamily._dependencies,
        allTransitiveDependencies: NewsFamily._allTransitiveDependencies,
        searchValue: searchValue,
        categoryValue: categoryValue,
      );

  NewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchValue,
    required this.categoryValue,
  }) : super.internal();

  final String? searchValue;
  final String? categoryValue;

  @override
  Override overrideWith(
    FutureOr<List<NewsData>> Function(NewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NewsProvider._internal(
        (ref) => create(ref as NewsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchValue: searchValue,
        categoryValue: categoryValue,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<NewsData>> createElement() {
    return _NewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NewsProvider &&
        other.searchValue == searchValue &&
        other.categoryValue == categoryValue;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchValue.hashCode);
    hash = _SystemHash.combine(hash, categoryValue.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NewsRef on AutoDisposeFutureProviderRef<List<NewsData>> {
  /// The parameter `searchValue` of this provider.
  String? get searchValue;

  /// The parameter `categoryValue` of this provider.
  String? get categoryValue;
}

class _NewsProviderElement
    extends AutoDisposeFutureProviderElement<List<NewsData>>
    with NewsRef {
  _NewsProviderElement(super.provider);

  @override
  String? get searchValue => (origin as NewsProvider).searchValue;
  @override
  String? get categoryValue => (origin as NewsProvider).categoryValue;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
