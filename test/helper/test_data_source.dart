import 'package:paging_view/paging_view.dart';

class TestDataSource extends DataSource<int, String> {
  TestDataSource({
    this.initialItems = const ['Item 1', 'Item 2', 'Item 3'],
    this.prependedItems = const ['Prepended Item'],
    this.appendedItems = const ['Appended Item'],
    this.hasErrorOnRefresh = false,
    this.hasErrorOnPrepend = false,
    this.hasErrorOnAppend = false,
  });

  final List<String> initialItems;
  final List<String> prependedItems;
  final List<String> appendedItems;
  final bool hasErrorOnRefresh;
  final bool hasErrorOnPrepend;
  final bool hasErrorOnAppend;

  @override
  Future<LoadResult<int, String>> load(LoadAction<int> action) async {
    return switch (action) {
      Refresh() => _handleRefresh(),
      Prepend(:final key) => _handlePrepend(key),
      Append(:final key) => _handleAppend(key),
    };
  }

  Future<LoadResult<int, String>> _handleRefresh() async {
    if (hasErrorOnRefresh) {
      return Failure(error: Exception('Refresh Error'));
    }
    return Success(
      page: PageData(
        data: initialItems,
        prependKey: initialItems.isNotEmpty ? -1 : null,
        appendKey: initialItems.isNotEmpty ? 1 : null,
      ),
    );
  }

  Future<LoadResult<int, String>> _handlePrepend(int key) async {
    if (hasErrorOnPrepend) {
      return Failure(error: Exception('Prepend Error'));
    }
    return Success(
      page: PageData(
        data: prependedItems,
        prependKey: null, // No more pages
      ),
    );
  }

  Future<LoadResult<int, String>> _handleAppend(int key) async {
    if (hasErrorOnAppend) {
      return Failure(error: Exception('Append Error'));
    }
    return Success(
      page: PageData(
        data: appendedItems,
        appendKey: null, // No more pages
      ),
    );
  }
}

class TestGroupedDataSource extends GroupedDataSource<int, String, String> {
  TestGroupedDataSource({
    this.initialItems = const ['A1', 'A2', 'B1', 'B2'],
    this.appendedItems = const ['C1', 'C2'],
    this.hasErrorOnRefresh = false,
    this.hasErrorOnAppend = false,
  });

  final List<String> initialItems;
  final List<String> appendedItems;
  final bool hasErrorOnRefresh;
  final bool hasErrorOnAppend;

  @override
  Future<LoadResult<int, String>> load(LoadAction<int> action) async {
    return switch (action) {
      Refresh() => _handleRefresh(),
      Prepend() => const None(),
      Append(:final key) => _handleAppend(key),
    };
  }

  Future<LoadResult<int, String>> _handleRefresh() async {
    if (hasErrorOnRefresh) {
      return Failure(error: Exception('Refresh Error'));
    }
    return Success(
      page: PageData(
        data: initialItems,
        appendKey: initialItems.isNotEmpty ? 1 : null,
      ),
    );
  }

  Future<LoadResult<int, String>> _handleAppend(int key) async {
    if (hasErrorOnAppend) {
      return Failure(error: Exception('Append Error'));
    }
    return Success(
      page: PageData(
        data: appendedItems,
        appendKey: null, // No more pages
      ),
    );
  }

  @override
  String groupBy(String value) {
    if (value.startsWith('A')) return 'Group A';
    if (value.startsWith('B')) return 'Group B';
    if (value.startsWith('C')) return 'Group C';
    return 'Other';
  }
}
