# paging_view

Like Android Jetpack's Paging library 3, manages data and displays paged lists.

## Usage

```dart
final dataSourcePublicRepositoriesProvider = Provider.autoDispose(
      (ref) => DataSourcePublicRepositories(
    repository: ref.watch(
      gitHubRepositoryProvider,
    ),
  ),
);

class DataSourcePublicRepositories extends DataSource<int, Repository> {
  DataSourcePublicRepositories({
    required this.repository,
  });

  final GitHubRepository repository;

  @override
  Future<LoadResult<int, Repository>> load(LoadParams<int> params) async {
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

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(dataSourcePublicRepositoriesProvider);

    final index = useState(BottomBarType.list);
    final Widget body;
    switch (index.value) {
      case BottomBarType.list:
        body = PagingList<int, Repository>(
          dataSource: dataSource,
          builder: (context, repository, index) {
            return Card(
              child: ListTile(
                title: Text(repository.fullName),
                subtitle: Text(repository.description),
              ),
            );
          },
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
        break;
      case BottomBarType.grid:
        body = PagingGrid<int, Repository>(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          dataSource: dataSource,
          builder: (context, repository, index) {
            return Card(
              child: ListTile(
                title: Text(repository.fullName),
                subtitle: Text(
                  repository.description,
                  maxLines: 3,
                ),
              ),
            );
          },
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
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub public repositories'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => dataSource.refresh(),
        child: body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_3x3),
            label: 'Grid',
          ),
        ],
        onTap: (value) {
          index.value = BottomBarType.values[value];
        },
        currentIndex: index.value.index,
      ),
    );
  }
}
```
