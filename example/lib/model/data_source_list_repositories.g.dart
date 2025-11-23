// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_list_repositories.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dataSource)
const dataSourceProvider = DataSourceProvider._();

final class DataSourceProvider
    extends
        $FunctionalProvider<
          ExampleDataSource,
          ExampleDataSource,
          ExampleDataSource
        >
    with $Provider<ExampleDataSource> {
  const DataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataSourceHash();

  @$internal
  @override
  $ProviderElement<ExampleDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExampleDataSource create(Ref ref) {
    return dataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExampleDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExampleDataSource>(value),
    );
  }
}

String _$dataSourceHash() => r'38bf2a1d7106b3463310bcdfe75b76cdf2053041';
