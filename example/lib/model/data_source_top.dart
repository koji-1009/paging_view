import 'package:example/model/entity/repository.dart';
import 'package:example/model/github_repository.dart';
import 'package:flutter_paging/flutter_paging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataSourceTopProvider = Provider.autoDispose(
  (ref) => DataSourceTop(
    repository: ref.watch(
      gitHubRepositoryProvider,
    ),
  ),
);

class DataSourceTop extends DataSource<Repository, int> {
  DataSourceTop({
    required this.repository,
  });

  final GitHubRepository repository;

  @override
  Future<LoadResult<Repository, int>> load(LoadParams<int> params) async {
    return params.when(
      refresh: () async {
        final data = await repository.repositories(null);
        return LoadResult.success(
          page: data,
        );
      },
      prepend: (_) {
        return const LoadResult.none();
      },
      append: (key) async {
        final data = await repository.repositories(key);
        return LoadResult.success(
          page: data,
        );
      },
    );
  }
}
