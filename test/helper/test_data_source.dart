import 'package:paging_view/paging_view.dart';

class TestDataSource extends DataSource<int, String> {
  TestDataSource({
    this.initialItems = const ['Item 1', 'Item 2', 'Item 3'],
    this.hasErrorOnRefresh = false,
    this.hasErrorOnPrepend = false,
    this.hasErrorOnAppend = false,
    this.maxAppendPages = 2,
    this.maxPrependPages = 0,
    this.refreshDelay = Duration.zero,
    this.prependDelay = Duration.zero,
    this.appendDelay = Duration.zero,
    this.prependItemBuilder,
    this.appendItemBuilder,
  });

  final List<String> initialItems;
  final bool hasErrorOnRefresh;
  final bool hasErrorOnPrepend;
  final bool hasErrorOnAppend;
  final int maxAppendPages;
  final int maxPrependPages;
  final Duration refreshDelay;
  final Duration prependDelay;
  final Duration appendDelay;
  final List<String> Function(int key)? prependItemBuilder;
  final List<String> Function(int key)? appendItemBuilder;

  @override
  Future<LoadResult<int, String>> load(LoadAction<int> action) async {
    return switch (action) {
      Refresh() => _handleRefresh(),
      Prepend(:final key) => _handlePrepend(key),
      Append(:final key) => _handleAppend(key),
    };
  }

  Future<LoadResult<int, String>> _handleRefresh() async {
    await Future.delayed(refreshDelay);
    if (hasErrorOnRefresh) {
      return Failure(error: Exception('Refresh Error'));
    }
    return Success(
      page: PageData(
        data: initialItems,
        prependKey: maxPrependPages > 0 ? -1 : null,
        appendKey: maxAppendPages > 0 ? 1 : null,
      ),
    );
  }

  Future<LoadResult<int, String>> _handlePrepend(int key) async {
    await Future.delayed(prependDelay);
    if (hasErrorOnPrepend) {
      return Failure(error: Exception('Prepend Error'));
    }
    if (key < -maxPrependPages) {
      return const None();
    }
    return Success(
      page: PageData(
        data: prependItemBuilder?.call(key) ?? ['Prepended Item $key'],
        prependKey: key - 1 >= -maxPrependPages ? key - 1 : null,
      ),
    );
  }

  Future<LoadResult<int, String>> _handleAppend(int key) async {
    await Future.delayed(appendDelay);
    if (hasErrorOnAppend) {
      return Failure(error: Exception('Append Error'));
    }
    if (key > maxAppendPages) {
      return const None();
    }
    return Success(
      page: PageData(
        data: appendItemBuilder?.call(key) ?? ['Appended Item $key'],
        appendKey: key + 1 <= maxAppendPages ? key + 1 : null,
      ),
    );
  }
}

class TestGroupedDataSource extends GroupedDataSource<int, String, String> {
  TestGroupedDataSource({
    this.initialItems = const ['A1', 'A2', 'B1', 'B2'],
    this.hasErrorOnRefresh = false,
    this.hasErrorOnPrepend = false,
    this.hasErrorOnAppend = false,
    this.maxAppendPages = 1,
    this.maxPrependPages = 0,
    this.refreshDelay = Duration.zero,
    this.prependDelay = Duration.zero,
    this.appendDelay = Duration.zero,
    this.prependItemBuilder,
    this.appendItemBuilder,
  });

  final List<String> initialItems;
  final bool hasErrorOnRefresh;
  final bool hasErrorOnPrepend;
  final bool hasErrorOnAppend;
  final int maxAppendPages;
  final int maxPrependPages;
  final Duration refreshDelay;
  final Duration prependDelay;
  final Duration appendDelay;
  final List<String> Function(int key)? prependItemBuilder;
  final List<String> Function(int key)? appendItemBuilder;

  @override
  Future<LoadResult<int, String>> load(LoadAction<int> action) async {
    return switch (action) {
      Refresh() => _handleRefresh(),
      Prepend(:final key) => _handlePrepend(key),
      Append(:final key) => _handleAppend(key),
    };
  }

  Future<LoadResult<int, String>> _handleRefresh() async {
    await Future.delayed(refreshDelay);
    if (hasErrorOnRefresh) {
      return Failure(error: Exception('Refresh Error'));
    }
    return Success(
      page: PageData(
        data: initialItems,
        prependKey: maxPrependPages > 0 ? -1 : null,
        appendKey: maxAppendPages > 0 ? 1 : null,
      ),
    );
  }

  Future<LoadResult<int, String>> _handlePrepend(int key) async {
    await Future.delayed(prependDelay);
    if (hasErrorOnPrepend) {
      return Failure(error: Exception('Prepend Error'));
    }
    if (key < -maxPrependPages) {
      return const None();
    }
    return Success(
      page: PageData(
        data: prependItemBuilder?.call(key) ?? ['Grouped Prepended Item $key'],
        prependKey: key - 1 >= -maxPrependPages ? key - 1 : null,
      ),
    );
  }

  Future<LoadResult<int, String>> _handleAppend(int key) async {
    await Future.delayed(appendDelay);
    if (hasErrorOnAppend) {
      return Failure(error: Exception('Append Error'));
    }
    if (key > maxAppendPages) {
      return const None();
    }
    return Success(
      page: PageData(
        data: appendItemBuilder?.call(key) ?? ['Grouped Appended Item $key'],
        appendKey: key + 1 <= maxAppendPages ? key + 1 : null,
      ),
    );
  }

  @override
  String groupBy(String value) {
    if (value.startsWith('A')) return 'Group A';
    if (value.startsWith('B')) return 'Group B';
    if (value.startsWith('C')) return 'Group C';
    if (value.startsWith('Grouped Appended Item')) return 'Group Appended';
    if (value.startsWith('Grouped Prepended Item')) return 'Group Prepended';
    return 'Other';
  }
}
