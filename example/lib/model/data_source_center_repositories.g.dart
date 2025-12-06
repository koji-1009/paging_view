// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_center_repositories.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(centerDataSource)
const centerDataSourceProvider = CenterDataSourceProvider._();

final class CenterDataSourceProvider
    extends
        $FunctionalProvider<
          ExampleCenterDataSource,
          ExampleCenterDataSource,
          ExampleCenterDataSource
        >
    with $Provider<ExampleCenterDataSource> {
  const CenterDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'centerDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$centerDataSourceHash();

  @$internal
  @override
  $ProviderElement<ExampleCenterDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExampleCenterDataSource create(Ref ref) {
    return centerDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExampleCenterDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExampleCenterDataSource>(value),
    );
  }
}

String _$centerDataSourceHash() => r'97c3f074282aa3cfb08f4c6e54fbac5e0772c045';
