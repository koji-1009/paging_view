import 'package:example/model/entity/repository.dart';
import 'package:example/model/github_repository.dart';
import 'package:paging_view/paging_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_source_public_repositories.g.dart';

@riverpod
DataSourcePublicRepositories dataSourcePublicRepositories(
  DataSourcePublicRepositoriesRef ref,
) {
  final dataSource = DataSourcePublicRepositories(
    repository: ref.watch(gitHubRepositoryProvider),
  );

  ref.onDispose(() {
    dataSource.dispose();
  });

  return dataSource;
}

final class DataSourcePublicRepositories extends DataSource<int, Repository> {
  DataSourcePublicRepositories({required this.repository});

  final GitHubRepository repository;

  @override
  Future<LoadResult<int, Repository>> load(LoadAction<int> action) async =>
      switch (action) {
        Refresh() => await fetch(null),
        Prepend(key: final _) => const None(),
        Append(key: final key) => await fetch(key),
      };

  Future<LoadResult<int, Repository>> fetch(int? key) async {
    final PageData<int, Repository> data;
    if (key == null) {
      data = await repository.repositories();
    } else {
      data = await repository.repositories(since: key);
    }
    return Success(page: data);
  }
}
