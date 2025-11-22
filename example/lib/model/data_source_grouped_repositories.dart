import 'package:example/model/entity/repository.dart';
import 'package:example/model/github_repository.dart';
import 'package:paging_view/paging_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_source_grouped_repositories.g.dart';

@riverpod
ExampleGroupedDataSource groupedDataSource(Ref ref) {
  final dataSource = ExampleGroupedDataSource(
    repository: ref.watch(gitHubRepositoryProvider),
  );

  ref.onDispose(() {
    dataSource.dispose();
  });

  return dataSource;
}

class ExampleGroupedDataSource
    extends GroupedDataSource<int, String, Repository> {
  ExampleGroupedDataSource({required this.repository});

  final GitHubRepository repository;

  @override
  Future<LoadResult<int, Repository>> load(LoadAction<int> action) async =>
      switch (action) {
        Refresh() => await fetch(null),
        Prepend() => const None(),
        Append(:final key) => await fetch(key),
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

  @override
  String groupBy(Repository value) => 'since: ${value.since}';
}
