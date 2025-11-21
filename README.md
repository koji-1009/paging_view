# paging_view

[![pub package](https://img.shields.io/pub/v/paging_view.svg)](https://pub.dev/packages/paging_view)
[![GitHub license](https://img.shields.io/github/license/koji-1009/paging_view)](https://github.com/koji-1009/paging_view/blob/main/LICENSE)

**paging_view** is a robust Flutter library for managing and displaying paginated data. Inspired by Android Jetpack's Paging library, it adopts a **DataSource-driven architecture**, enabling a clear separation between your data loading logic and the UI.

Whether you are building a simple infinite scroll list, a complex grid, a grouped list, or a sophisticated sliver-based layout, `paging_view` provides a type-safe and flexible foundation.

## Key Features

* Defines data loading logic in a dedicated `DataSource` class, keeping your Widgets clean and testable.
* `PagingList` and `PagingGrid` are wrappers around `PagingSliverList` and `PagingSliverGrid`. You can easily peel off the wrapper and use them directly in a `CustomScrollView`.
* Built-in support for `GroupedPagingList`, making it easy to render sectioned data (e.g., by date or category) with sticky headers.
* Supports `Refresh`, `Append` (load more), and `Prepend` (load previous/history), making it ideal for bidirectional lists like chat applications.
* Leverages modern Dart patterns (sealed classes/switch expressions) to handle loading states elegantly.
* Full control over loading indicators, error widgets, and empty states.

## Live Preview

👉 [See it in action!](https://koji-1009.github.io/paging_view/)

## Quick Start

### 1. Define a DataSource
Extend `DataSource` to connect your API or database. This cleanly isolates *how* you fetch data from *how* you display it.

```dart
class DataSourcePublicRepositories extends DataSource<int, Repository> {
  DataSourcePublicRepositories({required this.repository});

  final GitHubRepository repository;

  @override
  Future<LoadResult<int, Repository>> load(LoadAction<int> action) async =>
      switch (action) {
        Refresh() => await fetch(),
        Prepend() => const None(), // Useful for chat apps (load history)
        Append(:final key) => await fetch(key: key),
      };

  Future<LoadResult<int, Repository>> fetch({int? key}) async {
    final PageData<int, Repository> data = key == null
        ? await repository.repositories()
        : await repository.repositories(since: key);
    return Success(page: data);
  }
}
```

### 2. Display the List

Use `PagingList` (or `PagingGrid`) and provide your DataSource.

```dart
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Obtain the DataSource (e.g., using Riverpod)
    final dataSource = ref.watch(dataSourcePublicRepositoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('GitHub public repositories')),
      body: RefreshIndicator(
        onRefresh: () async => dataSource.refresh(),
        // 2. Pass it to the PagingList
        child: PagingList<int, Repository>(
          dataSource: dataSource,
          builder: (context, repository, index) => ListTile(
            title: Text(repository.fullName),
            subtitle: Text(repository.description),
          ),
          // Optional: Customize indicators
          errorBuilder: (context, error, stackTrace) => Center(child: Text('Error: $error')),
          initialLoadingWidget: const Center(child: CircularProgressIndicator.adaptive()),
          appendLoadingWidget: const Center(child: CircularProgressIndicator.adaptive()), 
        ),
      ),
    );
  }
}
```

## Advanced Usage

### Sliver Support

Since `paging_view` is built on top of Slivers, integrating with `CustomScrollView` is seamless. This is perfect for screens with collapsible headers or complex scroll effects.

```dart
CustomScrollView(
  slivers: [
    const SliverAppBar(
      title: Text('Sliver Example'),
      floating: true,
    ),
    // Use PagingSliverList directly
    PagingSliverList<int, Repository>(
      dataSource: dataSource,
      builder: (context, repository, index) => ListTile(
        title: Text(repository.fullName),
      ),
    ),
  ],
)
```

### Grouped Data

Easily handle sectioned lists (e.g., contacts grouped by initial, transaction history grouped by date) using `GroupedPagingList`.

```dart
GroupedPagingList<String, int, Item>(
  dataSource: groupedDataSource,
  // Define how to group your items
  groupBy: (item) => item.category,
  // Builder for the group header
  groupHeaderBuilder: (context, groupKey) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text('Group: $groupKey', style: Theme.of(context).textTheme.titleMedium),
  ),
  // Builder for the items
  itemBuilder: (context, item, index) => ListTile(title: Text(item.name)),
)
```

-----

See the [API documentation](https://pub.dev/documentation/paging_view/latest/) for details.
