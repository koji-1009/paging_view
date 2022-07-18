import 'package:example/model/entity/repository.dart';
import 'package:example/model/github_repository.dart';
import 'package:flutter_paging/flutter_paging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataSourcePublicRepositoriesProvider = Provider.autoDispose(
  (ref) => DataSourcePublicRepositories(
    repository: ref.watch(
      gitHubRepositoryProvider,
    ),
  ),
);

class DataSourcePublicRepositories extends DataSource<Repository, int> {
  DataSourcePublicRepositories({
    required this.repository,
  });

  final GitHubRepository repository;

  @override
  Future<LoadResult<Repository, int>> load(LoadParams<int> params) async {
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );

    return params.when(
      refresh: () async {
        final data = await repository.repositories();
        return LoadResult.success(
          page: data,
        );
      },
      prepend: (_) {
        return const LoadResult.none();
      },
      append: (key) async {
        final data = await repository.repositories(
          since: key,
        );
        return LoadResult.success(
          page: data,
        );
      },
    );
  }
}
