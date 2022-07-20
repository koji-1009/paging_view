import 'package:example/model/entity/repository.dart';
import 'package:example/model/github_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paging_view/paging_view.dart';

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
