// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_grouped_repositories.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(groupedDataSource)
const groupedDataSourceProvider = GroupedDataSourceProvider._();

final class GroupedDataSourceProvider
    extends
        $FunctionalProvider<
          ExampleGroupedDataSource,
          ExampleGroupedDataSource,
          ExampleGroupedDataSource
        >
    with $Provider<ExampleGroupedDataSource> {
  const GroupedDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupedDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupedDataSourceHash();

  @$internal
  @override
  $ProviderElement<ExampleGroupedDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExampleGroupedDataSource create(Ref ref) {
    return groupedDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExampleGroupedDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExampleGroupedDataSource>(value),
    );
  }
}

String _$groupedDataSourceHash() => r'c6138bbb5f1e3cf95ba82c4cbc4b0a9e66b80da3';
