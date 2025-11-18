// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gitHubRepository)
const gitHubRepositoryProvider = GitHubRepositoryProvider._();

final class GitHubRepositoryProvider
    extends
        $FunctionalProvider<
          GitHubRepository,
          GitHubRepository,
          GitHubRepository
        >
    with $Provider<GitHubRepository> {
  const GitHubRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gitHubRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gitHubRepositoryHash();

  @$internal
  @override
  $ProviderElement<GitHubRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GitHubRepository create(Ref ref) {
    return gitHubRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GitHubRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GitHubRepository>(value),
    );
  }
}

String _$gitHubRepositoryHash() => r'86113f19c1764724307c44308d6f469234be9aab';
