// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_public_repositories.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dataSourcePublicRepositories)
const dataSourcePublicRepositoriesProvider =
    DataSourcePublicRepositoriesProvider._();

final class DataSourcePublicRepositoriesProvider
    extends
        $FunctionalProvider<
          DataSourcePublicRepositories,
          DataSourcePublicRepositories,
          DataSourcePublicRepositories
        >
    with $Provider<DataSourcePublicRepositories> {
  const DataSourcePublicRepositoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataSourcePublicRepositoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataSourcePublicRepositoriesHash();

  @$internal
  @override
  $ProviderElement<DataSourcePublicRepositories> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DataSourcePublicRepositories create(Ref ref) {
    return dataSourcePublicRepositories(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataSourcePublicRepositories value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataSourcePublicRepositories>(value),
    );
  }
}

String _$dataSourcePublicRepositoriesHash() =>
    r'58e1200804da6c39bdc4f53ec519924e9af148d9';
