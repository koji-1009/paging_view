# paging_view

[![pub package](https://img.shields.io/pub/v/paging_view.svg)](https://pub.dev/packages/paging_view)
[![GitHub license](https://img.shields.io/github/license/koji-1009/paging_view)](https://github.com/koji-1009/paging_view/blob/main/LICENSE)
[![CI](https://github.com/koji-1009/paging_view/actions/workflows/analyze.yaml/badge.svg)](https://github.com/koji-1009/paging_view/actions/workflows/analyze.yaml)

**paging_view** is a robust Flutter library for managing and displaying paginated data. Inspired by Android Jetpack's Paging library, it adopts a **DataSource-driven architecture**, enabling a clear separation between your data loading logic and the UI.

Whether you are building a simple infinite scroll list, a complex grid, a grouped list, or a sophisticated sliver-based layout, `paging_view` provides a type-safe and flexible foundation.

## Features

- **Separation of Concerns**: Defines data loading logic in a dedicated `DataSource` class, keeping your Widgets clean, focused, and testable.
- **Versatile UI**:
  - `PagingList`, `PagingGrid`: High-level widgets for common use cases.
  - `SliverPagingList`, `SliverPagingGrid`: For use in a `CustomScrollView` to create sophisticated scroll effects (e.g., with an `SliverAppBar`).
- **Grouped Lists**: Built-in support for `GroupedPagingList` and `GroupedPagingGrid`, making it easy to render sectioned data (e.g., by date or category) with sticky headers.
- **Bidirectional Loading**: Supports `Refresh`, `Append` (load more), and `Prepend` (load previous/history), making it ideal for feeds and chat applications.
- **Modern & Type-Safe**: Leverages modern Dart patterns (sealed classes with switch expressions) to handle loading states elegantly.
- **Customizable**: Full control over loading indicators, error widgets, and empty states.

## Live Preview

https://koji-1009.github.io/paging_view/

## Getting Started

### 1. Installation

Add `paging_view` to your `pubspec.yaml` file:

```yaml
dependencies:
  paging_view: ^2.4.0 # Use the latest version
```

### 2. Define a DataSource

Create a class that extends `DataSource`. This is where you'll implement your logic for fetching data (e.g., from a network API or a local database).

For this example, we'll create a simple `ExampleDataSource` that paginates over a local list of items.

```dart
import 'package:flutter/material.dart';
import 'package:paging_view/paging_view.dart';

// Your data entity
typedef DemoEntity = ({
  String word,
  String description,
});

class ExampleDataSource extends DataSource<int, DemoEntity> {
  static const int pageSize = 20;

  // This would typically be your database or network client.
  // For this example, we use a simple list of 200 items.
  final allItems = List.generate(
    200,
    (index) => (word: 'Word $index', description: 'Description for word $index'),
  );

  @override
  Future<LoadResult<int, DemoEntity>> load(LoadAction<int> action) async {
    // This example only supports Append and Refresh.
    // For a chat app, you might implement Prepend.
    return switch (action) {
      Refresh() => await _fetch(0),
      Append(key: final pageKey) => await _fetch(pageKey),
      Prepend() => const None(),
    };
  }

  Future<LoadResult<int, DemoEntity>> _fetch(int pageKey) async {
    try {
      // Simulate a network delay.
      await Future.delayed(const Duration(seconds: 1));

      final start = pageKey;
      final items = allItems.skip(start).take(pageSize).toList();

      // Determine the key for the next page. If null, it means we've reached the end.
      final nextKey = start + pageSize < allItems.length ? start + pageSize : null;
      
      return Success(page: PageData(data: items, appendKey: nextKey));
    } catch (e, st) {
      return Failure(error: e, stackTrace: st);
    }
  }
}
```

### 3. Display the List

Now, use the `PagingList` widget and provide it with your `ExampleDataSource`.

```dart
class PagingListDemo extends StatefulWidget {
  const PagingListDemo({super.key});

  @override
  State<PagingListDemo> createState() => _PagingListDemoState();
}

class _PagingListDemoState extends State<PagingListDemo> {
  // It is recommended to keep the DataSource in a state management solution
  // (like Riverpod or Provider) rather than in a StatefulWidget.
  // This is a simplified example.
  late final ExampleDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = ExampleDataSource();
  }

  @override
  void dispose() {
    _dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _dataSource.refresh(),
      child: PagingList(
        dataSource: _dataSource,
        initialLoadingWidget: const Center(child: CircularProgressIndicator.adaptive()),
        appendLoadingWidget: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
        errorBuilder: (context, error, stackTrace) => Center(
          child: Text('An error occurred: $error'),
        ),
        emptyWidget: const Center(child: Text('No items found.')),
        builder: (context, entity, index) {
          return Card(
            child: ListTile(
              title: Text(entity.word),
              subtitle: Text(entity.description),
            ),
          );
        },
      ),
    );
  }
}
```

## Advanced Usage

### Sliver Support

Since `paging_view` is built on top of Slivers, integrating with `CustomScrollView` is seamless. This is perfect for screens with collapsible headers or other complex scroll effects.

A key aspect of this integration is the `CustomScrollView`'s `cacheExtent` property. By adjusting `cacheExtent`, you can control how far in advance (or behind) `paging_view` requests new data for `append` and `prepend` operations. A larger `cacheExtent` will trigger data loading earlier, providing a smoother user experience, especially during fast scrolling.

```dart
CustomScrollView(
  slivers: [
    const SliverAppBar(
      title: Text('Sliver Example'),
      floating: true,
    ),
    // Use SliverPagingList directly
    SliverPagingList(
      dataSource: dataSource,
      builder: (context, entity, index) => ListTile(
        title: Text(entity.word),
      ),
    ),
  ],
)
```

### Grouped Data

Easily handle sectioned lists (e.g., contacts grouped by initial, transaction history by date) using `GroupedPagingList`. You'll need to use a `GroupedDataSource`.

```dart
GroupedPagingList(
  dataSource: groupedDataSource,
  // Define how to group your items
  headerBuilder: (context, groupKey, index) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text('Group: $groupKey', style: Theme.of(context).textTheme.titleLarge),
  ),
  // Builder for each item in the group
  itemBuilder: (context, item, globalIndex, localIndex) => ListTile(title: Text(item.word)),
)
```

## API Reference

See the [API documentation](https://pub.dev/documentation/paging_view/latest/) for more details on all the available classes and widgets.
