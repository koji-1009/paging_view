import 'package:paging_view/paging_view.dart';

class TestCenterDataSource extends CenterDataSource<int, String> {
  TestCenterDataSource({
    this.initialItems = const ['Center 1', 'Center 2', 'Center 3'],
    this.hasErrorOnRefresh = false,
    this.hasErrorOnPrepend = false,
    this.hasErrorOnAppend = false,
    this.maxAppendPages = 2,
    this.maxPrependPages = 2,
    this.refreshDelay = Duration.zero,
    this.prependDelay = Duration.zero,
    this.appendDelay = Duration.zero,
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
        data: ['Prepended $key', 'Prepended ${key}b'],
        prependKey: key - 1 >= -maxPrependPages ? key - 1 : null,
        appendKey: null,
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
        data: ['Appended $key', 'Appended ${key}b'],
        prependKey: null,
        appendKey: key + 1 <= maxAppendPages ? key + 1 : null,
      ),
    );
  }
}
