# paging_view

Like Android Jetpack's Paging library 3, manages data and displays paged lists.

## Live preview

https://koji-1009.github.io/paging_view/

## How to use

1. Create a class that is extended `DataSource`.
2. Get an instance of the step 1 class in the widget.
3. Set the step 2 instance obtained to `PagingList` or `PagingGrid`.

```dart
@riverpod
DataSourcePublicRepositories dataSourcePublicRepositories(
    DataSourcePublicRepositoriesRef ref,
) {
  final dataSource = DataSourcePublicRepositories(
    repository: ref.watch(
      gitHubRepositoryProvider,
    ),
  );

  ref.onDispose(() {
    dataSource.dispose();
  });

  return dataSource;
}

/// 1
final class DataSourcePublicRepositories extends DataSource<int, Repository> {
  DataSourcePublicRepositories({
    required this.repository,
  });

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
      data = await repository.repositories(
        since: key,
      );
    }
    return Success(
      page: data,
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 2
    final dataSource = ref.watch(dataSourcePublicRepositoriesProvider);
    final body = PagingList<int, Repository>(
      /// 3
      dataSource: dataSource,
      builder: (context, repository, index) => Card(
        child: ListTile(
          title: Text(repository.fullName),
          subtitle: Text(repository.description),
        ),
      ),
      errorBuilder: (context, e) => Center(
        child: Text('$e'),
      ),
      initialLoadingWidget: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
      appendLoadingWidget: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub public repositories'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => dataSource.refresh(),
        child: body,
      ),
    );
  }
}
```
