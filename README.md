# paging_view

[![pub package](https://img.shields.io/pub/v/paging_view.svg)](https://pub.dev/packages/paging_view)
[![GitHub license](https://img.shields.io/github/license/koji-1009/paging_view)](https://github.com/koji-1009/paging_view/blob/main/LICENSE)
[![CI](https://github.com/koji-1009/paging_view/actions/workflows/analyze.yaml/badge.svg)](https://github.com/koji-1009/paging_view/actions/workflows/analyze.yaml)
[![codecov](https://codecov.io/gh/koji-1009/paging_view/branch/main/graph/badge.svg)](https://codecov.io/gh/koji-1009/paging_view)

**paging_view** is a robust Flutter library for managing and displaying paginated data. Inspired by Android Jetpack's Paging library, it adopts a **DataSource-driven architecture**, enabling a clear separation between your data loading logic and the UI.

Whether you are building a simple infinite scroll list, a complex grid, a grouped list, or a sophisticated sliver-based layout, `paging_view` provides a type-safe and flexible foundation.

## Features

- **Separation of Concerns**: Defines data loading logic in a dedicated `DataSource` class, keeping your Widgets clean, focused, and testable.
- **Real-time Data Updates**: `DataSource` allows dynamic `updateItem`, `updateItems`, `insertItem`, and `removeItem` operations for seamless UI synchronization.
- **Versatile UI**:
  - `PagingList`, `PagingGrid`: High-level widgets for common use cases.
  - `SliverPagingList`, `SliverPagingGrid`: For use in a `CustomScrollView` to create sophisticated scroll effects (e.g., with an `SliverAppBar`).
- **Grouped Lists**: Built-in support for `GroupedPagingList` and `GroupedPagingGrid`, making it easy to render sectioned data (e.g., by date or category) with sticky headers.
- **Bidirectional Loading**: Supports `Refresh`, `Append` (load more), and `Prepend` (load previous/history), making it ideal for feeds and chat applications.
- **Manual Paging Control**: Provides `autoLoadAppend=false` and `autoLoadPrepend=false` options for widgets and explicit `dataSource.append()`/`prepend()` calls for fine-grained control over data loading.
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
      Append(:final pageKey) => await _fetch(pageKey),
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

#### Updating Data in DataSource

`DataSource` provides methods to dynamically update, insert, or remove individual items or a collection of items based on their position (index) or a predicate, allowing for real-time UI updates without a full data refresh.

```dart
// Assuming 'dataSource' is an instance of your DataSource
// and 'DemoEntity' is your item type, which in this example is
// typedef DemoEntity = ({String word, String description,});

// Update a single item at a specific index
// This example updates the item at index 1.
dataSource.updateItem(
  1, // The index of the item to update
  (oldItem) => (
    word: oldItem.word,
    description: 'UPDATED: ${oldItem.description}',
  ),
);

// Update multiple items based on a condition or transformation
// This example prepends the index to the word of each item.
dataSource.updateItems(
  (index, item) => (
    word: '$index: ${item.word}',
    description: item.description,
  ),
);

// Insert a new item at a specific index
dataSource.insertItem(
  0, // The index where the item should be inserted
  (word: 'New Item', description: 'This is a newly added item.'),
);

// Remove an item at a specific index
dataSource.removeItem(2); // Removes the item at index 2

// Remove multiple items based on a condition
// This example removes all items whose word starts with 'Updated'.
dataSource.removeItems(
  (index, item) => item.word.startsWith('Updated'),
);
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
        initialLoadingWidget: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        appendLoadingWidget: const Center(
          child: Padding(
            padding: .all(16.0),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
        errorBuilder: (context, error, stackTrace) => Center(
          child: Text('An error occurred: $error'),
        ),
        emptyWidget: const Center(child: Text('No items found.')),
        builder: (context, entity, index) => Card(
          child: ListTile(
            title: Text(entity.word),
            subtitle: Text(entity.description),
          ),
        ),
      ),
    );
  }
}
```

### 4. Displaying Grids

For a grid layout, you can use `PagingGrid` with a `SliverGridDelegate` (e.g., `SliverGridDelegateWithFixedCrossAxisCount`).

```dart
class PagingGridDemo extends StatefulWidget {
  const PagingGridDemo({super.key});

  @override
  State<PagingGridDemo> createState() => _PagingGridDemoState();
}

class _PagingGridDemoState extends State<PagingGridDemo> {
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
      child: PagingGrid(
        dataSource: _dataSource,
        initialLoadingWidget: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        appendLoadingWidget: const Center(
          child: Padding(
            padding: .all(16.0),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
        errorBuilder: (context, error, stackTrace) => Center(
          child: Text('An error occurred: $error'),
        ),
        emptyWidget: const Center(child: Text('No items found.')),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items per row
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0, // Square items
        ),
        builder: (context, entity, index) => Card(
          child: Center(
            child: Text(entity.word),
          ),
        ),
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

### Manual Load Mode

In some scenarios, you might want to control when to load more data explicitly, rather than relying on automatic scroll detection. `paging_view` supports a manual load mode for this purpose.

To enable manual load mode, set `autoLoadPrepend: false` and `autoLoadAppend: false` in your `PagingList`, `PagingGrid`, `SliverPagingList`, or `SliverPagingGrid` widget. You can then trigger loading more data by calling `dataSource.append()` or `dataSource.prepend()` manually, for example, via a button press.

```dart
class ManualLoadDemo extends StatefulWidget {
  const ManualLoadDemo({super.key});

  @override
  State<ManualLoadDemo> createState() => _ManualLoadDemoState();
}

class _ManualLoadDemoState extends State<ManualLoadDemo> {
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
      child: CustomScrollView(
        slivers: [
          SliverPagingList(
            dataSource: _dataSource,
            // Disable automatic loading
            autoLoadPrepend: false,
            autoLoadAppend: false,
            initialLoadingWidget: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text('An error occurred: $error'),
            ),
            emptyWidget: const Center(child: Text('No items found.')),
            builder: (context, entity, index) => Card(
              child: ListTile(
                title: Text(entity.word),
                subtitle: Text(entity.description),
              ),
            ),
          ),
          AppendLoadStateBuilder(
            dataSource: _dataSource,
            builder: (context, hasMore, isLoading) => SliverToBoxAdapter(
              child: SizedBox(
                height: 64,
                child: isLoading
                    ? const Center(
                        child: Padding(
                          padding: .all(16),
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      )
                    : hasMore
                    ? Padding(
                        padding: const .all(16),
                        child: FilledButton(
                          onPressed: () => _dataSource.append(),
                          child: const Text('Load More'),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Error Handling Policy & Load Callbacks

`DataSource` provides fine-grained control over how errors are handled during `refresh`, `prepend`, or `append` operations, and allows you to observe the outcome of every load via a callback.

- **`LoadErrorPolicy` Enum**: Configures whether the `DataSource` should enter an error state or silently ignore errors for specific actions.
  - **Default behavior**: If an error occurs, the `DataSource` updates its state to `Failure`. Paging widgets will typically display an error widget with `errorBuilder`.
  - **`LoadErrorPolicy.ignoreRefresh`**: If a refresh fails, the error is ignored, and the list retains its current items.
  - **`LoadErrorPolicy.ignorePrepend` / `ignoreAppend`**: If loading more items fails, the error is ignored, and the state reverts to the last successful state. This is useful when you want to suppress the default error view and handle retry logic externally (e.g., showing a SnackBar or a custom button outside the list).
- **`onLoadFinished` Callback**: A callback invoked after every `load()` operation completes.
  - **Signature**: `void Function(LoadAction action, LoadResult result)`
  - **Purpose**: Ideal for analytics, logging, showing transient messages (like `SnackBar`), or managing external UI state for retries.

**Example: Implementing a Custom Retry Button**

By using `LoadErrorPolicy.ignoreAppend`, the `DataSource` will not show an error in the list when an append fails. Instead, we use `onLoadFinished` to detect the failure and show a custom retry button in the UI.

First, configure your `DataSource` to ignore append errors:

```dart
class MyRetryableDataSource extends DataSource<int, String> {
  MyRetryableDataSource(): super(errorPolicy: {.ignoreAppend});
}
```

Then, in your UI, listen to the result to manage the error state locally:

```dart
class RetryableLoadDemo extends StatefulWidget {
  const RetryableLoadDemo({super.key});

  @override
  State<RetryableLoadDemo> createState() => _RetryableLoadDemoState();
}

class _RetryableLoadDemoState extends State<RetryableLoadDemo> {
  Object? _appendError;

  late final MyRetryableDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = MyRetryableDataSource();
    
    // Listen for load results to update UI state
    _dataSource.onLoadFinished = (action, result) {
      if (!mounted) return;

      if (action is Append) {
        setState(() {
          if (result is Failure) {
            _appendError = result.error;
          } else {
            // Clear error on success
            _appendError = null;
          }
        });
      }
    };
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
      child: CustomScrollView(
        slivers: [
          SliverPagingList(
            dataSource: _dataSource,
            builder: (context, item, index) => 
              ListTile(title: Text(item)),
          ),
          // Custom Footer for Retry
          SliverToBoxAdapter(
            child: _appendError != null
                ? Padding(
                    padding: const .all(16),
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          _appendError = null;
                        });
                        _dataSource.append();
                      },
                      child: const Text('Retry Load More'),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
```

## CenterPagingList: Bidirectional Pagination with Center Anchor

`CenterPagingList` provides advanced bidirectional pagination using `CustomScrollView`'s center key mechanism. This widget is ideal for scenarios where you need to load data in both directions while maintaining a stable scroll anchor point.

### Key Concepts

Unlike the standard `DataSource` which manages a single list of pages, `CenterDataSource` manages three separate segments:

- **Prepend Pages**: Pages loaded via `prepend()` (displayed above the center)
- **Center Pages**: The initial page(s) loaded via `refresh()` (the anchor point)
- **Append Pages**: Pages loaded via `append()` (displayed below the center)

The center segment uses a `GlobalKey` to mark its position in the `CustomScrollView`. When new prepend pages are loaded, existing prepend content moves to the center segment, ensuring the scroll position remains stable.

### When to Use CenterPagingList

- **Chat applications**: Load older messages (prepend) and newer messages (append) around the current view
- **Timeline feeds**: Browse content in both directions with stable scroll position
- **Infinite scrolling with history**: Load past and future data dynamically

**Example: Implementing a CenterPagingList**

```dart
class CenterPagingListDemo extends StatefulWidget {
  const CenterPagingListDemo({super.key});

  @override
  State<CenterPagingListDemo> createState() => _CenterPagingListDemoState();
}

class _CenterPagingListDemoState extends State<CenterPagingListDemo> {
  late final MyCenterDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = MyCenterDataSource();
  }

  @override
  void dispose() {
    _dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CenterPagingList(
      dataSource: _dataSource,
      initialLoadingWidget: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      errorBuilder: (context, error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
      emptyWidget: const Center(child: Text('No items')),
      builder: (context, item, index) => ListTile(
        title: Text(item),
      ),
      prependLoadStateBuilder: (context, hasMore, isLoading) {
        if (isLoading) {
          return SizedBox(
            height: 64,
            child: const Center(
              child: Padding(
                padding: .all(16),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          );
        }
        if (!hasMore) {
          return SizedBox(
            height: 64,
            child: Padding(
              padding: const .all(16),
              child: FilledButton(
                onPressed: () => dataSource.prepend(),
                child: const Text('Load Previous'),
              ),
            ),
          );
        }
        return null;
      },
      appendLoadStateBuilder: (context, hasMore, isLoading) {
        if (isLoading) {
          return SizedBox(
            height: 64,
            child: const Center(
              child: Padding(
                padding: .all(16),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          );
        }
        if (hasMore) {
          return SizedBox(
            height: 64,
            child: Padding(
              padding: const .all(16),
              child: FilledButton(
                onPressed: () => dataSource.append(),
                child: const Text('Load More'),
              ),
            ),
          );
        }
        return null;
    );
  }
}
```

## API Reference

See the [API documentation](https://pub.dev/documentation/paging_view/latest/) for more details on all the available classes and widgets.
